meta:
  id: goldenland2_sdb
  title: "Златогорье 2 SDB"
  file-extension: sdb
  endian: le
  bit-endian: le
seq:
  - id: signature
    type: str
    size: 4
    encoding: "windows-1251"
  - id: data
    type: string_entry
    repeat: eos
    if: signature=="SDB "
instances:
  encrypted_data:
    pos: 0
    type: encrypted_string_entry
    repeat: eos
    if: signature!="SDB "
types:
  string_entry:
    seq:
      - id: id
        type: u4
      - id: len
        type: u4
      - id: text
        size: len
        type: str
        encoding: "windows-1251"
  encrypted_string_entry:
    seq:
      - id: id
        type: u4
      - id: len
        type: u4
      - id: text
        size: len
        process: xor(0xAA)
        type: str_wrapper
  str_wrapper:
    seq:
      - id: value
        size-eos: true
        type: str
        encoding: "windows-1251"
