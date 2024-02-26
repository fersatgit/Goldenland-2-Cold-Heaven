meta:
  id: goldenland2_pak
  title: "Златогорье 2 PAK"
  file-extension: pak
  endian: le
  bit-endian: le
seq:
  - id: signature
    contents: ["P","A","K"," ",0,0,0,0]
  - id: file_count  
    type: u4
  - id: fat
    type: file
    repeat: expr
    repeat-expr: file_count
types:
  file:
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
        encoding: "windows-1251"
      - id: size
        type: u4
      - id: offset
        type: u4
    instances:
      stream:
        pos: offset
        type: stream
  stream:
    seq:
      - id: compressed
        type: u4
      - id: zlib_stream
        type: zlibstream
        if: compressed==1
      - id: data  
        size-eos: true
        if: compressed==0
  zlibstream:
    seq:
      - id: size  
        type: u4
      - id: data
        size: size
        process: zlib