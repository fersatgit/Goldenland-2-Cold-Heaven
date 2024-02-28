meta:
  id: goldenland2_csx
  title: "Златогорье 2 CSX"
  file-extension: csx
  endian: le
  bit-endian: le
seq:
  - id: color_count  
    type: u4
  - id: transparent_color
    type: bgra
  - id: palette
    type: bgra
    repeat: expr
    repeat-expr: color_count
  - id: width
    type: u4
  - id: height
    type: u4
  - id: lines
    type: lines
    size: height*4+4
  - id: compressed_data
    size-eos: true
types:
  lines:
    seq:
      - id: lines
        type: line
        repeat: until
        repeat-until: (_._io.pos>_root.height*4-4)or(_.next==-1) #We must access to "next" for normal work
                                                                 #It`s a hack, but it`s works
  line:
    seq:
      - id: offset
        type: u4
    instances:
      next:
        pos: _io.pos
        type: u4
      data:
        io: _root._io
        pos: offset+(_root.color_count+_root.height)*4+20
        size: next-offset
  bgra:
    seq:
      - id: b
        type: u1
      - id: g
        type: u1
      - id: r
        type: u1
      - id: a
        type: u1