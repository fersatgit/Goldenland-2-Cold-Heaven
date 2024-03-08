library Goldenland2;
{$E wlx}

//Exclude unnecessary code/data from output dll
{$IMAGEBASE $400000} //Base address (used in LoadIconW)
{$G-}                //Imported data
{$R-}                //Range checking
{$M-}                //Run-Time Type Information
{$Y-}                //Symbol declaration and cross-reference information
{$D-}                //debug information
{$C-}                //Asserts
{$L-}                //Local Symbols
{$Q-}                //Overflow checking
{$O+}                //Optimization
{$R 1.res}

uses
  Windows,Messages,CommCtrl,listplug;

function wsprintfW(out buf;fmt:PWideChar): dword;varargs;cdecl;external user32;
function wsprintfA(out buf;fmt:PAnsiChar): dword;varargs;cdecl;external user32;

type
  TSDB= packed record
        ItemCount: dword;
        size:      dword;
        data:      PAnsiChar;
        Items:     array of PAnsiChar;
        end;

  TITM= packed record
        Id:           dword;
        PuppetNameLen:dword;
        PuppetName:   PAnsiChar;
        IconNameLen:  dword;
        IconName:     PAnsiChar;
        Shell:        PAnsiChar;        
        Material:     dword;        
        DescId:       dword;
        _type:        dword;
        Flags:        dword;
        MaxStack:     dword;
        Level:        dword;
        Strenght:     dword;
        Wisdom:       dword;
        Endurance:    dword;
        Intelligence: dword;
        Perception:   dword;
        Agility:      dword;
        Charge:       dword;
        Damage:       packed record
                      CrushMin,CrushMax: dword;
                      HackMin,HackMax:   dword;
                      SlashMin,SlashMax: dword;
                      end;
        Healing:      packed record
                      Health,Mana: integer;
                      end;
        Price:        dword;
        Weight:       dword;
        SpellId:      dword;
        Receipe:      packed record
                      Item1,Item2,ResultItem: dword;
                      end;
        DamageType:   dword;
        EffectsCount: dword;
        Effects:      array[0..19] of packed record //in game EffectsCount cannot exceed 20
                                      Id:             dword;
                                      Amount:         integer;
                                      flags:          dword;
                                      duration,delay: word;
                                      end;
        size:         dword;
        data:         PAnsiChar;
        FileNameLen:  dword;
        FileName:     PWideChar;
        end;
  PITM=^TITM;

function LoadFile(FileToLoad: PWideChar;out data: PAnsiChar; out size: dword): boolean;
var
  f: THandle;
  i: dword;
begin
  result:=false;
  f:=CreateFileW(FileToLoad,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,0,0);
  data:=nil;
  size:=GetFileSize(f,0);
  if size<>INVALID_FILE_SIZE then
  begin
    data:=VirtualAlloc(0,size,MEM_COMMIT,PAGE_READWRITE);
    ReadFile(f,data^,size,i,0);
    result:=true;
    if i<>size then
    begin
      VirtualFree(data,size,MEM_DECOMMIT);
      result:=false;
    end;
  end;
  CloseHandle(f);
end;

function LoadITM(var _itm: TITM): boolean;
var
  i,len: dword;
begin
  with _itm do
  begin
    ZeroMemory(@_itm,sizeof(TITM)-Sizeof(FileName)-Sizeof(FileNameLen));
    result:=false;
    if LoadFile(FileName,data,size) and (pdword(@data[0])^=4) then
    begin
      move(data[4],DescId,16);
      PuppetNameLen:=pdword(@data[20])^;
      PuppetName:=nil;
      if PuppetNameLen>0 then
        PuppetName:=@data[24];
      i:=PuppetNameLen+24;
      IconNameLen:=pdword(@data[i])^;
      IconName:=nil;
      if IconNameLen>0 then
        IconName:=@data[i+4];
      inc(i,IconNameLen+12);
      move(data[i],Price,8);
      inc(i,32);
      Material:=pdword(@data[i])^;
      inc(i,4);
      if Flags and 16>0 then
      begin
        len:=pdword(@data[i])^;
        Shell:=nil;
        if len>0 then
          Shell:=@data[i+4];
        inc(i,len+4);
      end;
      move(data[i],Level,28);
      inc(i,28);
      if _type in [0..7,11..14] then
      begin
        move(data[i],Damage,sizeof(Damage));
        inc(i,sizeof(Damage));
      end;
      if _type in [6,21,22] then
      begin
        SpellId:=pdword(@data[i])^;
        inc(i,8);
      end;
      case _type of
          6:begin
            Charge:=pdword(@data[i])^;
            inc(i,4);
            end;
      19,20:begin
            move(data[i],Healing,sizeof(Healing));
            inc(i,sizeof(Healing));
            end;
         26:begin
            move(data[i],Receipe,sizeof(Receipe));
            inc(i,sizeof(Receipe));
            end;
      8..10:begin
            DamageType:=pdword(@data[i])^;
            inc(i,4);
            end;
      end;
      EffectsCount:=pdword(@data[i])^;
      if EffectsCount>0 then
      begin
        if EffectsCount>length(Effects) then
          EffectsCount:=length(Effects);
        move(data[i+4],Effects,EffectsCount*sizeof(Effects[0]));
        for i:=EffectsCount-1 downto 0 do
          with Effects[i] do
          begin
            duration:=lo(duration)*(30 shl ord(lo(duration)>1))+hi(duration);
            delay:=lo(delay)*(30 shl ord(lo(delay)>1))+hi(delay);
          end;
      end;
      result:=true;
    end;
  end;
end;

function LoadSDB(FileToLoad: PWideChar;out _sdb: TSDB): boolean;
var
  k:           LongInt;
  len,id,i,j:  dword;
begin
  with _sdb do
  begin
    result:=false;
    itemCount:=0;
    if LoadFile(FileToLoad,data,size) then
    begin
      result:=true;
      //ordinary file
      if pdword(@data[0])^=$20424453 then //"SDB "
      begin
        i:=4;
        j:=4;
        repeat
          if itemCount<pdword(@data[j])^ then;
            itemCount:=pdword(@data[j])^;
          inc(j,pdword(@data[j+4])^+8);
        until j>=size;
      end
      //encrypted file
      else
      begin
        i:=0;
        j:=0;
        repeat
          if itemCount<pdword(@data[j])^ then;
            itemCount:=pdword(@data[j])^;
          len:=pdword(@data[j+4])^;
          inc(j,8);
          for k:=len-1 downto 0 do
            data[j+k]:=AnsiChar(ord(data[j+k]) xor $AA);
          inc(j,len);
        until j>=size;
      end;
      inc(itemCount);
      SetLength(Items,itemCount);

      id:=pdword(@data[i])^;
      repeat
        len:=pdword(@data[i+4])^;
        Items[id]:=@data[i+8];
        id:=pdword(@data[i+8+len])^;
        data[i+8+len]:=#0;
        inc(i,len+8);
      until i>=size;
    end;
  end;
end;

function WndProc(wnd,msg,wParam,lParam: dword):dword;stdcall;
label
  FreeRes;
const
  //this strings can be found in "scripts\item_class_specials\init.scr", I don`t want to parse it
  EffectsNames:        array[0..64] of PWideChar=('повреждение ядом','повреждение холодом','повреждение огнём','сопротивление яду','сопротивление холоду','сопротивление огню','сила','телосложение','внимание','ловкость',
                                                  'интелект','мудрость','удача','сопротивляемость магии богов','сопротивляемость магии стихий','сопротивляемость магии света','сопротивляемость магии тьмы','сопротивляемость магии теней',
                                                  'сопротивляемость магии природы','сопротивляемость рубящим повреждениям','сопротивляемость дробящим повреждениям','сопротивляемость колющим повреждениям',
                                                  'максимальное количество здоровья','максимальное количество энергии','инициатива','скорость восстановления здоровья','скорость восстановления энергии',
                                                  'очки действия','слава','класс брони','переносимый вес','воровство жизни','воровство энергии','рубящие повреждения','дробящие повреждения','колющие повреждения',
                                                  'повреждения магией богов','повреждения магией стихий','повреждения магией света','повреждения магией тьмы','повреждения магией теней','повреждения магией природы',
                                                  'иммунитет к магии богов','иммунитет к магии стихий','иммунитет к магии света','иммунитет к магии тьмы','иммунитет к магии теней','иммунитет к магии природы',
                                                  'здоровье','энергия','точность','Шанс на критический удар','Повреждения при критическом ударе','Шанс на критический промах','Разговорчивость','Осторожность',
                                                  'Меткость выстрела','Стрелковые повреждения','Призыв привидения','Один безопасный переход по карте','Призыв горного демона','Призыв крылатого демона',
                                                  'Снятие всех заклинаний, наложенных на цель','Невозможность использования заклинаний целью','Призыв виолии');
  ListViewColumns:     array[0..4] of tagLVCOLUMNW=((mask: LVCF_TEXT+LVCF_WIDTH;cx:100;pszText:'Эффект'),(mask: LVCF_TEXT+LVCF_WIDTH;cx:100;pszText:'Сила'),(mask: LVCF_TEXT+LVCF_WIDTH;cx:150;pszText:'Длительность'),(mask: LVCF_TEXT+LVCF_WIDTH;cx:100;pszText:'Задержка'),(mask: LVCF_TEXT+LVCF_WIDTH;cx:150;pszText:'Условия'));
  //In game actualy no names for item types
  ItemTypes:           array[0..28] of PWideChar=('меч','топор','копьё','лук','арбалет','винтовка','посох','дробящее оружие','патроны','болты','стрелы','шлем','кираса','щит','поножи','браслет','амулет','кольцо','деньги','зелье','еда','книга','свиток','кузнечный материал','алхимический ингридиент','квестовый предмет','рецепт','мусор','камень');
  IconCoords:          array[0..28] of TPoint=((X:16;Y:176),(X:16;Y:176),(X:16;Y:176),(X:16;Y:176),(X:16;Y:176),(X:16;Y:176),(X:16;Y:176),(X:16;Y:176),//Weapons
                                               (X:210;Y:176),(X:210;Y:176),(X:210;Y:176),                                                              //Ammo
                                               (X:61;Y:11),                                                                                            //Helm
                                               (X:10;Y:251),                                                                                           //Armor
                                               (X:210;Y:176),                                                                                          //Shield
                                               (X:210;Y:251),                                                                                          //Leg armor
                                               (X:10;Y:117),                                                                                           //bracelet
                                               (X:167;Y:17),                                                                                           //amulet
                                               (X:10;Y:74),                                                                                            //ring
                                               (X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176),(X:210;Y:176));
  //constants only needs to calc lenght in compile time, actualy it not be stored in output dll
  ItemDescriptionsPathConst='..\..\sdb\items\descriptions.sdb';
  MaterialsPathConst       ='..\..\sdb\items\materials.sdb';
  ItemLitNamesPathConst    ='..\..\sdb\items\lit_names.sdb';
  ItemTechNamesPathConst   ='..\..\sdb\items\tech_names.sdb';
  MagicTechNamesPathConst  ='..\..\sdb\magic\magictechnames.sdb';
  MagicLitNamesPathConst   ='..\..\sdb\magic\magiclitnames.sdb';
  MagicIconsCastPathConst  ='..\engineres\interface\magic_book\magic_icons\cast_na\';
  //This strings will be stored in output dll
  ItemDescriptionsPath:PWideChar=ItemDescriptionsPathConst;
  MaterialsPath:       PWideChar=MaterialsPathConst;
  ItemLitNamesPath:    PWideChar=ItemLitNamesPathConst;
  ItemTechNamesPath:   PWideChar=ItemTechNamesPathConst;
  MagicTechNamesPath:  PWideChar=MagicTechNamesPathConst;
  MagicLitNamesPath:   PWideChar=MagicLitNamesPathConst;
  MagicIconsCastPath:  PWideChar=MagicIconsCastPathConst;
var
  bmp:                  tagBITMAP;
  i,j:                  dword;
  strBuf:               array[0..4095] of WideChar;
  DC,DC1,DC2,bmp1,bmp2: THandle;
  lvitem:               tagLVITEMW;
  ItemDescriptions,ItemLitNames,Materials,ItemTechNames,MagicTechNames,MagicLitNames: TSDB;

begin
  result:=0;
  case msg of
  WM_INITDIALOG:with PITM(lParam)^ do
                begin
                i:=FileNameLen;
                repeat
                  dec(i);
                until FileName[i]='\';
                val(PWideChar(@FileName[i+1]),id,j);
                move(FileName^,strBuf,i*2+2);
                move(ItemDescriptionsPath^,strBuf[i+1],length(ItemDescriptionsPathConst)*2+2);
                LoadSDB(strBuf,ItemDescriptions);
                move(ItemLitNamesPath^,strBuf[i+1],length(ItemLitNamesPathConst)*2+2);
                LoadSDB(strBuf,ItemLitNames);
                move(MaterialsPath^,strBuf[i+1],length(MaterialsPathConst)*2+2);
                LoadSDB(strBuf,Materials);
                move(ItemTechNamesPath^,strBuf[i+1],length(ItemTechNamesPathConst)*2+2);
                LoadSDB(strBuf,ItemTechNames);
                if (ItemDescriptions.data=nil)or(ItemLitNames.data=nil)or(Materials.data=nil)or(ItemTechNames.data=nil) then
                  goto FreeRes;

                //Draw person, item icon and item    
                j:=GetDlgItem(wnd,1);
                DC:=GetDC(j);
                DC1:=CreateCompatibleDC(DC);
                DC2:=CreateCompatibleDC(DC);
                bmp1:=CreateBitmap(274,324,1,32,0);
                lstrcpyW(@strBuf[i+7],'engineres\hero_generator\main.bmp');
                bmp2:=LoadImageW(0,@strBuf,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION+LR_LOADFROMFILE);
                SelectObject(DC1,bmp1);
                SelectObject(DC2,bmp2);
                BitBlt(DC1,0,0,274,324,DC2,6,296,SRCCOPY);
                DeleteObject(bmp2);
                lstrcpyW(@strBuf[i+4],'res\');
                strBuf[i+8+MultiByteToWideChar(1251,0,PuppetName,PuppetNameLen,@strBuf[i+8],length(strBuf)-i-8)]:=#0;
                bmp2:=LoadImageW(0,@strBuf,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION+LR_LOADFROMFILE);
                SelectObject(DC2,bmp2);
                GetObject(bmp2,sizeof(bmp),@bmp);
                TransparentBlt(DC1,0,324-bmp.bmHeight,bmp.bmWidth,bmp.bmHeight,DC2,0,0,bmp.bmWidth,bmp.bmHeight,$FF00FF);
                DeleteObject(bmp2);
                strBuf[i+8+MultiByteToWideChar(1251,0,IconName,IconNameLen,@strBuf[i+8],length(strBuf)-i-8)]:=#0;
                bmp2:=LoadImageW(0,@strBuf,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION+LR_LOADFROMFILE);
                SelectObject(DC2,bmp2);
                GetObject(bmp2,sizeof(bmp),@bmp);
                with IconCoords[_Type] do
                  TransparentBlt(DC1,X,Y,bmp.bmWidth,bmp.bmHeight,DC2,0,0,bmp.bmWidth,bmp.bmHeight,$FF00FF);
                DeleteObject(bmp2);
                ReleaseDC(j,DC);
                DeleteDC(DC2);
                DeleteDC(DC1);
                SendMessageW(j,STM_SETIMAGE,IMAGE_BITMAP,bmp1);

                //Recipes item-lists initialization (take long time)
                SendDlgItemMessageW(wnd,36,CB_INITSTORAGE,ItemLitNames.ItemCount,ItemLitNames.size);
                SendDlgItemMessageW(wnd,37,CB_INITSTORAGE,ItemLitNames.ItemCount,ItemLitNames.size);
                SendDlgItemMessageW(wnd,38,CB_INITSTORAGE,ItemLitNames.ItemCount,ItemLitNames.size);
                for j:=0 to ItemLitNames.ItemCount-1 do
                begin
                  SendDlgItemMessageA(wnd,36,CB_ADDSTRING,0,LongInt(ItemLitNames.Items[j]));
                  SendDlgItemMessageA(wnd,37,CB_ADDSTRING,0,LongInt(ItemLitNames.Items[j]));
                  SendDlgItemMessageA(wnd,38,CB_ADDSTRING,0,LongInt(ItemLitNames.Items[j]));
                end;

                for j:=0 to length(ItemTypes)-1 do
                  SendDlgItemMessageW(wnd,3,CB_ADDSTRING,0,LongInt(ItemTypes[j]));
                SendDlgItemMessageW(wnd,3,CB_SETCURSEL,_Type,0);
                for j:=0 to length(Materials.Items)-1 do
                  SendDlgItemMessageA(wnd,4,CB_ADDSTRING,0,LongInt(Materials.Items[j]));
                SendDlgItemMessageW(wnd,4,CB_SETCURSEL,Material,0);

                //For staffs, scrolls and magic books we need to show magic icon
                if _Type in [6,21,22] then
                begin
                  move(MagicTechNamesPath^,strBuf[i+1],length(MagicTechNamesPathConst)*2+2);
                  LoadSDB(strBuf,MagicTechNames);
                  move(MagicLitNamesPath^,strBuf[i+1],length(MagicLitNamesPathConst)*2+2);
                  LoadSDB(strBuf,MagicLitNames);
                  move(MagicIconsCastPath^,strBuf[i+4],length(MagicIconsCastPathConst)*2+2);
                  j:=i+4+length(MagicIconsCastPathConst);
                  lstrcpyW(@strBuf[j+MultiByteToWideChar(1251,0,MagicTechNames.Items[SpellId],pdword(dword(MagicTechNames.Items[SpellId])-4)^,@strBuf[j],length(strBuf)-j)],'.bmp');
                  SendDlgItemMessageW(wnd,35,STM_SETIMAGE,IMAGE_BITMAP,LoadImageW(0,strBuf,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION+LR_LOADFROMFILE+LR_LOADTRANSPARENT));
                end
                //Recipe`s
                else if _Type=26 then
                begin
                  SendDlgItemMessageA(wnd,36,CB_SETCURSEL,Receipe.Item1,0);
                  SendDlgItemMessageA(wnd,37,CB_SETCURSEL,Receipe.Item2,0);
                  SendDlgItemMessageA(wnd,38,CB_SETCURSEL,Receipe.ResultItem,0);
                end
                //Damage type checkboxes for ammo
                else if _Type in [8..10] then
                begin
                  SendDlgItemMessageW(wnd,40,BM_SETCHECK,DamageType and 1,0);
                  SendDlgItemMessageW(wnd,41,BM_SETCHECK,(DamageType shr 1) and 1,0);
                  SendDlgItemMessageW(wnd,42,BM_SETCHECK,(DamageType shr 2) and 1,0);
                end;

                PAnsiChar(@strBuf)[wsprintfA(strBuf,'%s (%s)',ItemLitNames.Items[Id],ItemTechNames.Items[Id])]:=#0;
                SendDlgItemMessageA(wnd,2,WM_SETTEXT,0,LongInt(@strBuf));
                SendDlgItemMessageA(wnd,39,WM_SETTEXT,0,LongInt(ItemDescriptions.Items[DescId]));

                for i:=0 to 18 do
                begin
                  strBuf[wsprintfW(strBuf,'%i',pdword(@PAnsiChar(@MaxStack)[i*4])^)]:=#0;
                  SendDlgItemMessageW(wnd,i+16,WM_SETTEXT,0,LongInt(@strBuf));
                end;

                //Item flags
                SendDlgItemMessageW(wnd,5,BM_SETCHECK,Flags and 1,0);
                SendDlgItemMessageW(wnd,6,BM_SETCHECK,(Flags shr 1) and 1,0);
                SendDlgItemMessageW(wnd,7,BM_SETCHECK,(Flags shr 2) and 1,0);
                SendDlgItemMessageW(wnd,8,BM_SETCHECK,(Flags shr 3) and 1,0);
                SendDlgItemMessageW(wnd,9,BM_SETCHECK,(Flags shr 4) and 1,0);
                SendDlgItemMessageW(wnd,10,BM_SETCHECK,(Flags shr 5) and 1,0);
                SendDlgItemMessageW(wnd,11,BM_SETCHECK,(Flags shr 6) and 1,0);
                SendDlgItemMessageW(wnd,12,BM_SETCHECK,(Flags shr 7) and 1,0);
                SendDlgItemMessageW(wnd,13,BM_SETCHECK,(Flags shr 8) and 1,0);
                SendDlgItemMessageW(wnd,14,BM_SETCHECK,(Flags shr 30) and 1,0);
                SendDlgItemMessageW(wnd,15,BM_SETCHECK,Flags shr 31,0);

                //Table of effaects
                for i:=0 to length(ListViewColumns)-1 do
                  SendDlgItemMessageW(wnd,43,LVM_INSERTCOLUMNW,i,LongInt(@ListViewColumns[i]));

                if EffectsCount>0 then
                begin
                   lvitem.mask:=LVIF_TEXT;
                   lvitem.iItem:=EffectsCount;
                   lvitem.iItem:=0;
                   repeat
                     with Effects[lvitem.iItem] do
                     begin
                       lvitem.iSubItem:=0;
                       lvitem.pszText:=EffectsNames[Id];
                       SendDlgItemMessageW(wnd,43,LVM_INSERTITEMW,0,LongInt(@lvitem));
                       lvitem.iSubItem:=1;
                       lvitem.pszText:=@strBuf;
                       i:=ord(' %'[(Flags shr 7) and 1+1]);
                       case id of
                        0..2,36..41:strBuf[wsprintfW(strBuf,'%i-%i%c',round(Amount*0.8),round(Amount*1.1),i)]:=#0;
                              25,26:strBuf[wsprintfW(strBuf,'%c%i%c',ord('-+'[ord(-Amount>0)+1]),abs(Amount),i)]:=#0;
                       else
                         strBuf[wsprintfW(strBuf,'%c%i%c',ord('-+'[ord(Amount>0)+1]),abs(Amount),i)]:=#0;
                       end;
                       SendDlgItemMessageW(wnd,43,LVM_SETITEMW,0,LongInt(@lvitem));
                       lvitem.iSubItem:=2;
                       strBuf[wsprintfW(strBuf,'%u',Duration)]:=#0;
                       SendDlgItemMessageW(wnd,43,LVM_SETITEMW,0,LongInt(@lvitem));
                       lvitem.iSubItem:=3;
                       strBuf[wsprintfW(strBuf,'%u',Delay)]:=#0;
                       SendDlgItemMessageW(wnd,43,LVM_SETITEMW,0,LongInt(@lvitem));
                       lvitem.iSubItem:=4;
                       strBuf[0]:=#0;
                       if flags and 1>0 then
                         lstrcatW(@strBuf,'постоянно ');
                       if flags and 2>0 then
                         lstrcatW(@strBuf,'днём ');
                       if flags and 4>0 then
                         lstrcatW(@strBuf,'ночью ');
                       SendDlgItemMessageW(wnd,43,LVM_SETITEMW,0,LongInt(@lvitem));
                     end;
                     inc(lvitem.iItem);
                   until lvitem.iItem=EffectsCount;
                   SendDlgItemMessageW(wnd,43,LVM_SETCOLUMNWIDTH,0,LVSCW_AUTOSIZE);
                end;

                FreeRes:
                VirtualFree(ItemDescriptions.data,ItemDescriptions.size,0);
                VirtualFree(ItemLitNames.data,ItemLitNames.size,0);
                VirtualFree(Materials.data,Materials.size,0);
                VirtualFree(ItemTechNames.data,ItemTechNames.size,0);
                end;
  end;
end;

function ListLoadW(ParentWin: THandle;FileToLoad: PWideChar;ShowFlags: dword): THandle;stdcall;
const
  columns: array[0..1] of tagLVCOLUMNW=((mask: LVCF_TEXT; pszText: 'Id'#0),
                                        (mask: LVCF_TEXT; pszText: 'Текст'#0;iSubItem:1));
var
  lvitemA: tagLVITEMA;
  lvitemW: tagLVITEMW;
  i:       integer;
  len:     dword;
  sdb:     TSDB;
  itm:     TITM;
  FileExt: int64;
  strBuf:  array[0..4095] of WideChar;
  f:       THandle;
begin
  result:=0;
  len:=lstrlenW(FileToLoad);
  FileExt:=pint64(@FileToLoad[len-3])^;
  CharUpperW(@FileExt);
  if FileExt=$4200440053 then //SDB
  begin
    if LoadSDB(FileToLoad,sdb) then
    begin
      result:=CreateWindowExW(0,WC_LISTVIEW,0,WS_CHILD+LVS_REPORT+WS_VISIBLE,0,0,0,0,ParentWin,0,0,0);
      SendMessageW(result,LVM_INSERTCOLUMNW,0,LongInt(@columns[0]));
      SendMessageW(result,LVM_INSERTCOLUMNW,1,LongInt(@columns[1]));
      lvitemA.mask:=LVIF_TEXT;
      lvitemA.iItem:=0;
      lvitemA.iSubItem:=1;
      lvitemW.mask:=LVIF_TEXT;
      lvitemW.iItem:=0;
      lvitemW.iSubItem:=0;
      lvitemW.pszText:=@strBuf;
      SendMessageW(result,WM_SETREDRAW,0,0);
      for i:=0 to sdb.ItemCount-1 do
        if sdb.Items[i]<>nil then
        begin
          strBuf[wsprintfW(strBuf,'%i',i)]:=#0;
          SendMessageW(result,LVM_INSERTITEMW,0,LongInt(@lvitemW));
          lvitemA.pszText:=sdb.Items[i];
          SendMessageA(result,LVM_SETITEMA,0,LongInt(@lvitemA));
          inc(lvitemA.iItem);
          inc(lvitemW.iItem);
        end;
        SendMessageW(result,LVM_SETCOLUMNWIDTH,0,LVSCW_AUTOSIZE);
        SendMessageW(result,LVM_SETCOLUMNWIDTH,1,LVSCW_AUTOSIZE);
        SendMessageW(result,WM_SETREDRAW,1,0);
      end;
      VirtualFree(sdb.data,sdb.size,0);
      SetLength(sdb.Items,0);
  end
  else if FileExt=$4D00540049 then //ITM
  begin
    itm.FileNameLen:=len;
    itm.FileName:=FileToLoad;
    if LoadITM(itm) then
      result:=CreateDialogParamW(hInstance,PWideChar(1),ParentWin,@WndProc,LongInt(@itm));
  end;
end;

function ListLoad(ParentWin: THandle;FileToLoad: PAnsiChar;ShowFlags: dword): THandle;stdcall;
var
  filename: array[0..4095] of WideChar;
begin
 MultiByteToWideChar(1251,0,FileToLoad,-1,@filename,length(filename));
 ListLoadW(ParentWin,filename,ShowFlags);
end;

function ListGetPreviewBitmapW(FileToLoad:PWideChar;width,height:integer;contentbuf:PAnsiChar;contentbuflen:integer):hbitmap; stdcall;
var
  len,i:                    dword;
  itm:                      TITM;
  FileExt:                  int64;
  strBuf:                   array[0..4095] of WideChar;
  bmp:                      tagBITMAP;
  DC,DC1,DC2,bmp1,bmp2,wnd: THandle;
begin
  len:=lstrlenW(FileToLoad);
  FileExt:=pint64(@FileToLoad[len-3])^;
  CharUpperW(@FileExt);
  result:=0;
  if FileExt=$4D00540049 then //ITM
  begin
    itm.FileNameLen:=len;
    itm.FileName:=FileToLoad;
    if LoadITM(itm)and(itm.IconNameLen>0) then
    begin
      i:=len;
      repeat
        dec(i);
      until FileToLoad[i]='\';
      move(FileToLoad^,strBuf,i*2+2);
      lstrcpyW(@strbuf[i+1],'..\res\');
      strBuf[MultiByteToWideChar(1251,0,itm.IconName,itm.IconNameLen,@strBuf[i+8],length(strBuf)-len-8)+i+8]:=#0;
      wnd:=GetDesktopWindow;
      DC:=GetDC(wnd);
      DC1:=CreateCompatibleDC(DC);
      DC2:=CreateCompatibleDC(DC);
      result:=CreateCompatibleBitmap(DC,width,height);
      bmp1  :=LoadImageW(0,@strBuf,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION+LR_LOADFROMFILE);
      SelectObject(DC2,result);
      SelectObject(DC1,bmp1);
      GetObject(bmp1,sizeof(bmp),@bmp);
      StretchBlt(DC2,0,0,width,height,DC1,0,0,bmp.bmWidth,bmp.bmHeight,SRCCOPY);
      ReleaseDC(wnd,DC);
      DeleteDC(DC1);
      DeleteDC(DC2);
      DeleteObject(bmp1);
    end;
  end;
end;

function ListGetPreviewBitmap(FileToLoad:PAnsiChar;width,height:integer;contentbuf:PAnsiChar;contentbuflen:integer):hbitmap; stdcall;
var
  filename: array[0..4095] of WideChar;
begin
 MultiByteToWideChar(1251,0,FileToLoad,-1,@filename,length(filename));
 result:=ListGetPreviewBitmapW(filename,width,height,contentbuf,contentbuflen);
end;

procedure ListGetDetectString(DetectString:PAnsiChar;maxlen:integer);stdcall;
begin
  lstrcpynA(DetectString,'EXT="ITM" | EXT="SDB"',maxlen);
end;

exports
  ListLoad,
  ListLoadW,
  ListGetPreviewBitmap,
  ListGetPreviewBitmapW,
  ListGetDetectString;

begin
  InitCommonControls;
end.
