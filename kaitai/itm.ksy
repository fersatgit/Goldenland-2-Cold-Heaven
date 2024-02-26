meta:
  id: goldenland2_itm
  title: "Златогорье 2 ITM"
  file-extension: itm
  endian: le
  bit-endian: le
seq:
  - id: magic
    type: u4
  - id: description_id
    type: u4
  - id: item_type
    type: u4
    enum: itemtypes
  - id: item_flags
    size: 4
    type: itemflags
  - id: max_stack
    type: u4    
  - id: puppet_name
    type: string
  - id: icon_name
    type: string    
  - id: unknown
    size: 8
  - id: price
    type: u4
  - id: weight
    type: weight
  - id: unknown2
    size: 24
  - id: material  
    type: u4
    enum: materials
  - id: shell
    type: string
    if: item_flags.shell
  - id: reqirements
    type: requirements
  - id: damage
    type: damage
    if: (item_type.to_i<8)or((item_type.to_i>10)and(item_type.to_i<15))or(item_type.to_i==28)
  - id: spell
    type: spell
    if: (item_type.to_i==6)or(item_type.to_i==21)or(item_type.to_i==22)
  - id: charge  
    type: u4
    if: item_type.to_i==6
  - id: healing
    type: healing
    if: (item_type.to_i==19)or(item_type.to_i==20)
  - id: receipe
    type: receipe
    if: item_type.to_i==26
  - id: damage_type
    type: damagetypes
    if: (item_type.to_i>7)and(item_type.to_i<11)
  - id: effects_count
    type: u4
  - id: effects
    type: effect
    repeat: expr
    repeat-expr: effects_count
types:
  weight:
    seq:
      - id: value
        type: u4
    instances:
      calculated:
        value: value*0.1
  effect:
    seq:
      - id: type
        type: u4
        enum: effecttypes
      - id: amount
        type: s4
      - id: flags
        size: 4  
        type: effectflags
      - id: duration
        type: time
      - id: delay
        type: time
  time:
    seq:
      - id: hi
        type: u1
      - id: lo
        type: u1  
    instances:
      calculated:
        value: hi*(hi<2?30:60)+lo
  spell:
    seq:
      - id: spell_id
        type: u4
      - id: unknown
        type: u4
  receipe:
    seq: 
      - id: item_id_1
        type: u4
      - id: item_id_2
        type: u4
      - id: result_item_id
        type: u4  
  healing:
    seq:
      - id: health
        type: s4
      - id: mana
        type: s4  
  damage:
    seq:
      - id: crush_min
        type: u4
      - id: crush_max
        type: u4
      - id: hack_min
        type: u4
      - id: hack_max
        type: u4
      - id: slash_min
        type: u4
      - id: slash_max
        type: u4
  requirements:
    seq:
      - id: level
        type: u4
      - id: strenght
        type: u4
      - id: wisdom
        type: u4
      - id: endurance
        type: u4
      - id: intelligence
        type: u4
      - id: perception
        type: u4
      - id: agility
        type: u4
  string:
    seq:
      - id: len
        type: u4
      - id: string
        type: str
        size: len
        encoding: "windows-1251"
  itemflags:
    seq:
      - id: two_hands
        type: b1 # 0x01
      - id: unknown
        type: b1 # 0x02
      - id: unknown2
        type: b1 # 0x04
      - id: unbreakable
        type: b1 # 0x08
      - id: shell
        type: b1 # 0x10
      - id: unique
        type: b1 # 0x20
      - id: cursed
        type: b1 # 0x40
      - id: unknown3
        type: b1 # 0x80
      - id: forged
        type: b1 # 0x100        
  damagetypes:
    seq:
      - id: crush
        type: b1
      - id: hack
        type: b1
      - id: slash
        type: b1 
  effectflags:
    seq:
      - id: always
        type: b1 # 0x01
      - id: day
        type: b1 # 0x02
      - id: night
        type: b1 # 0x04
      - id: unused
        type: b1 # 0x08
      - id: duration
        type: b1 # 0x10
      - id: delay
        type: b1 # 0x20
      - id: number
        type: b1 # 0x40
      - id: percent
        type: b1 # 0x80
      - id: unknown
        type: b1 # 0x100
enums:
  itemtypes:
    0:  sword
    1:  axe
    2:  spear
    3:  bow
    4:  crossbow
    5:  gun
    6:  staff
    7:  club
    8:  ammo
    9:  bolt
    10: arrow
    11: helm
    12: armor
    13: shield
    14: leg_armor
    15: bracelet
    16: amulet
    17: ring
    18: mioney
    19: potion
    20: food
    21: book
    22: scroll
    23: material
    24: ingridient
    25: quest_item
    26: receipe
    27: trash
    28: stone
  materials:
    0xFFFFFFFF: unknown
    0: diamond
    1: bronze
    2: bulat
    3: black
    4: iron
    5: blood
    6: platinum
    7: silver
    8: gold
    9: sky
    10: organic
    11: meteorite
    12: tauline
    13: stone
    14: wood
  effecttypes:
    0: poison_damage
    1: cold_damage
    2: fire_damage
    3: poison_resist
    4: cold_resist
    5: fire_resist
    6: strenght
    7: endurance
    8: perception
    9: agility
    10: intelligence
    11: wisdom
    12: luck
    13: god_magic_resist
    14: elemental_magic_resist
    15: light_magic_resist
    16: dark_magic_resist
    17: shadow_magic_resist
    18: nature_magic_resist
    19: hack_damage_resist
    20: crush_damage_resist
    21: slash_damage_resist
    22: max_health
    23: max_mana
    24: initiative
    25: healing
    26: mana_restore
    27: hit_points
    28: honor
    29: armor_class
    30: max_weight
    31: health_theft
    32: mana_theft
    33: hack_damage
    34: crush_damage
    35: slash_damage
    36: god_magic_damage
    37: elemental_magic_damage
    38: light_magic_damage
    39: dark_magic_damage
    40: shadow_magic_damage
    41: nature_magic_damage
    42: remove_all_spell_effects
    43: safe_travel
    44: block_magic
    45: ghost_summon