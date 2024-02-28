{$E usr}
library CSX;

uses
  Windows;

const
PluginLabel: PAnsiChar='Goldenland 2'#0;
GFP_RGB=0;
GFP_BGR=1;
GFP_READ =$0001;
GFP_WRITE=$0002;

type
GFP_COLORMAP=packed record
             red:   array[0..255] of byte;
             green: array[0..255] of byte;
             blue:  array[0..255] of byte;
             end;
PGFP_COLORMAP=^GFP_COLORMAP;

TFileInfo=record
          handle:           dword;
          size:             dword;
          map:              dword;
          width:            dword;
          height:           dword;
          PalLen:           dword;
          transparentColor: dword;
          palette:          array of packed record
                                            b,g,r,a: byte;
                                            end;
          data,offsets:     array of dword;
          compressedData:   array of byte;
          end;
PFileInfo=^TFileInfo;

TSaveFileInfo=packed record
              handle:           dword;
              PalLen:           dword;
              TransparentColor: dword;
              width:            dword;
              height:           dword;
              bufsize:          dword;
              buf:              array of byte;
              CompressedData:   array of byte;
              palette:          array of dword;
              offsets:          array of dword;
              end;
PSaveFileInfo=^TSaveFileInfo;

function gfpGetPluginInfo(version: dword; _label: PAnsiChar; label_max_size: dword; extension: PAnsiChar; extension_max_size: dword; support: pdword): longbool;stdcall;
begin
  result:=version=2;
  lstrcpynA(_label,PluginLabel,label_max_size);
  lstrcpynA(extension,'csx',extension_max_size);
  support^:=GFP_READ+GFP_WRITE;
end;

function gfpLoadPictureInit(filename: PAnsiChar): pointer;stdcall;
begin
  result:=new(PFileInfo);
  with PFileInfo(result)^ do
  begin
    handle:=CreateFileA(filename,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
    size:=GetFileSize(handle,nil);
    map:=CreateFileMappingW(handle,nil,PAGE_READONLY,0,0,nil);
    pointer(data):=MapViewOfFile(map,FILE_MAP_READ,0,0,0);
  end;
end;

function gfpLoadPictureGetInfo(ptr: PFileInfo; pictype,width,height,dpi,bits_per_pixel,bytes_per_line,has_colormap: pdword; _label: PAnsiChar; label_max_size: dword): longbool;stdcall;
var
  i: dword;
begin
  result:=false;
  with ptr^ do
  begin
    if pointer(data)=nil then
      exit;
    PalLen                 :=data[0];
    transparentColor       :=data[1];
    pointer(palette)       :=@data[2];
    i                      :=PalLen+2;
    width                  :=data[i];
    height                 :=data[i+1];
    pointer(offsets)       :=@data[i+2];
    pointer(compressedData):=@offsets[height+1];
    for i:=PalLen-1 downto 0 do
      if pdword(@palette[i])^=transparentColor then
      begin
        transparentColor:=i;
        break;
      end;  
  end;
  width^         :=ptr^.width;
  height^        :=ptr^.height;
  bits_per_pixel^:=8;
  pictype^       :=GFP_RGB;
  dpi^           :=68;
  bytes_per_line^:=width^;
  has_colormap^  :=1;
  lstrcpynA(_label,PluginLabel,label_max_size);
  result:=true;
end;

function gfpLoadPictureGetLine(ptr: PFileInfo; line: dword; buffer: pbyte): longbool;stdcall;
var
  i,color,rep: dword;
begin
  with ptr^ do
  begin
    i:=offsets[line];
    repeat
      color:=compressedData[i];
      rep  :=1;
      inc(i);
      case color of
      $69:color:=transparentColor;
      $6A:begin
          color:=compressedData[i];
          rep  :=compressedData[i+1];
          inc(i,2);
          end;
      $6B:begin
          color:=compressedData[i];
          inc(i);
          end;
      $6C:begin
          color:=transparentColor;
          rep  :=compressedData[i];
          inc(i);
          end;
      end;
      fillchar(buffer^,rep,color);
      inc(buffer,rep);
    until i>=offsets[line+1];
  end;
  result:=true;
end;

function gfpLoadPictureGetColormap(ptr: PFileInfo; cmap: PGFP_COLORMAP): longbool;stdcall;
var
  i:dword;
begin
  with ptr^,cmap^ do
    for i:=PalLen-1 downto 0 do
    begin
      red[i]  :=palette[i].r;
      green[i]:=palette[i].g;
      blue[i] :=palette[i].b;
    end;
  result:=true;
end;

procedure gfpLoadPictureExit(ptr: PFileInfo);stdcall;
begin
  with ptr^ do
  begin
    UnmapViewOfFile(data);
    CloseHandle(map);
    CloseHandle(handle);
    pointer(offsets):=nil;
    pointer(data):=nil;
    pointer(palette):=nil;
    pointer(compressedData):=nil;
    dispose(ptr);
  end;
end;

function gfpSavePictureIsSupported(width,height,bits_per_pixel,has_colormap: dword): longbool; stdcall;
begin
  result:=(has_colormap>0)and(bits_per_pixel<9);
end;

function gfpSavePictureInit(filename: PAnsiChar; _width,_height,bits_per_pixel,dpi: dword; pictype: pdword; _label: PAnsiChar;label_max_size:dword): pointer;stdcall;
begin
  result:=new(PSaveFileInfo);
  with PSaveFileInfo(result)^ do
  begin
    pictype^:=GFP_RGB;
    handle:=CreateFileA(filename,GENERIC_WRITE,0,nil,CREATE_ALWAYS,0,0);
    width:=_width;
    height:=_height;
    PalLen:=1 shl bits_per_pixel;
    TransparentColor:=$FF00FF;
    bufsize:=width*height+height*4+1044;
    pointer(buf):=VirtualAlloc(nil,bufsize,MEM_COMMIT,PAGE_READWRITE);
    pdword(@buf[0])^:=PalLen;
    pdword(@buf[4])^:=TransparentColor;
    pointer(palette):=@buf[8];
    palette[PalLen]:=width;
    palette[PalLen+1]:=height;
    pointer(offsets):=@palette[PalLen+2];
    pointer(compressedData):=@offsets[height+1];
    lstrcpynA(_label,PluginLabel,label_max_size);
  end;
end;

function gfpSavePicturePutColormap(ptr: PSaveFileInfo; cmap: PGFP_COLORMAP): longbool;stdcall;
var
  i:       dword;
begin
  with ptr^,cmap^ do
    for i:=PalLen-1 downto 0 do
      palette[i]:=(((red[i] shl 8)+green[i]) shl 8)+blue[i];
  result:=true;
end;

function gfpSavePicturePutLine(ptr: PSaveFileInfo; line: dword; buffer: pointer): longbool;stdcall;
var
  RLEBlock:  packed record
                    code,color,rep: byte;
                    end;
  i,ofs,len: dword;
  input:     array of byte absolute buffer;
begin
  with ptr^,RLEBlock do
  begin
    i:=0;
    ofs:=offsets[line];
    repeat
      rep:=1;
      len:=1;
      color:=input[i];
      while (i<width-1)and(rep<255)and(input[i+rep]=color) do
        inc(rep);
      if rep>1 then
      begin
        if palette[color]=TransparentColor then
        begin
          code:=$6C;
          color:=rep;
          len:=2;
        end
        else
        begin
          code:=$6A;
          len:=3;
        end;
      end
      else if palette[color]=TransparentColor then
        code:=$69
      else if color in [$69..$6C] then
      begin
        code:=$6B;
        len:=2;
      end
      else
        code:=color;
      pdword(@compressedData[ofs])^:=pdword(@RLEBlock)^;
      inc(ofs,len);
      inc(i,rep);
    until i>=width;
    buffer:=nil;
    offsets[line+1]:=ofs;
    if line=height-1 then
      WriteFile(handle,buf[0],(PalLen+Height)*4+20+ofs,i,nil);
  end;
  result:=true;
end;

procedure gfpSavePictureExit(ptr: PSaveFileInfo);stdcall;
begin
  with ptr^ do
  begin
    CloseHandle(handle);
    VirtualFree(buf,bufsize,MEM_DECOMMIT);    
    pointer(palette):=nil;
    pointer(offsets):=nil;
    pointer(compressedData):=nil;
    pointer(buf):=nil;
    Dispose(ptr);
  end;
end;

exports
  gfpGetPluginInfo index 1,
  gfpLoadPictureExit index 2,
  gfpLoadPictureGetColormap index 3,
  gfpLoadPictureGetInfo index 4,
  gfpLoadPictureGetLine index 5,
  gfpLoadPictureInit index 6,
  gfpSavePictureExit index 7,
  gfpSavePictureInit index 8,
  gfpSavePictureIsSupported index 9,
  gfpSavePicturePutLine index 10,
  gfpSavePicturePutColormap index 11;

begin
end.
