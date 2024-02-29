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
    0: idspec_poison_dmg	
    1: idspec_cold_dmg
    2: idspec_fire_dmg
    3: idspec_poison_res
    4: idspec_cold_res
    5: idspec_fire_res
    6: idspec_strength
    7: idspec_constitution
    8: idspec_perception
    9: idspec_dexterity
    10: idspec_intelligence
    11: idspec_wisdom
    12: idspec_luck
    13: idspec_gods_magic_res
    14: idspec_elements_magic_res
    15: idspec_lightness_magic_res
    16: idspec_darkness_magic_res
    17: idspec_shadows_magic_res
    18: idspec_nature_magic_res
    19: idspec_hacking_res
    20: idspec_crushing_res
    21: idspec_pricking_res
    22: idspec_max_health
    23: idspec_max_energy
    24: idspec_initiative
    25: idspec_health_regenerate_time
    26: idspec_energy_regenerate_time
    27: idspec_action_points	
    28: idspec_reputation
    29: idspec_armor_class
    30: idspec_max_weight_carried
    31: idspec_transfer_health
    32: idspec_transfer_energy
    33: idspec_hacking_dmg
    34: idspec_crushing_dmg
    35: idspec_pricking_dmg
    36: idspec_gods_magic_dmg
    37: idspec_elements_magic_dmg
    38: idspec_lightness_magic_dmg
    39: idspec_darkness_magic_dmg
    40: idspec_shadows_magic_dmg
    41: idspec_nature_magic_dmg
    42: idspec_gods_magic_immun
    43: idspec_elements_magic_immun
    44: idspec_lightness_magic_immun
    45: idspec_darkness_magic_immun
    46: idspec_shadows_magic_immun
    47: idspec_nature_magic_immun
    48: idspec_health_current
    49: idspec_energy_current
    50: idspec_cht_hit
    51: idspec_cht_critical_hit
    52: idspec_mod_critical_hit
    53: idspec_cht_critical_miss
    54: idspec_cht_dialog_level
    55: idspec_cht_run_from_evil
    56: idspec_cht_hit_throwing
    57: idspec_dmg_throwing
    58: idspec_summon_demishadow
    59: idspec_map_walker
    60: idspec_summon_ice_beast
    61: idspec_summon_winged_demon
    62: idspec_dispell
    63: idspec_silence
    64: idspec_summon_violia