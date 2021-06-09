extends Node2D

#==== Modifier IDs ====#
# on hit i-frames        0
# poison                 1
# luck                   2
# shield                 3
# regenerating shield    4
# regenerating health    5
# bigger jump            6
# extra jump             7
# extra health           8

#==== Modifier Types ====#
# passive                0
# tick                   1
# delayed                2
# received_hit           3
# received_effect        4
# condition              5





#==== Variables ====#
var _modifier_list # list of modifier id: [modifier_prefab, modifier_types[] ]



#==== Bootstrap ====#
func initialize():
	initialize_modifier_prefabs()

func initialize_modifier_prefabs():
	_modifier_list = []
	
	# on hit i-frames: 0
	_modifier_list.append([])
	_modifier_list[0].append( load("res://Modifiers/OnHitIframes/OnHitIframes.tscn") )
	_modifier_list[0].append([1])
	
	# poison: 1
	_modifier_list.append([])
	_modifier_list[1].append( load("res://Modifiers/Poison/Poison.tscn") )
	_modifier_list[1].append([1])
	
	# luck: 2
	_modifier_list.append([])
	_modifier_list[2].append( load("res://Modifiers/Luck/Luck.tscn") )
	_modifier_list[2].append([0])
	
	# shield: 3
	_modifier_list.append([])
	_modifier_list[3].append( load("res://Modifiers/Shield/Shield.tscn") )
	_modifier_list[3].append([3])
	
	# regenerating shield: 4
	_modifier_list.append([])
	_modifier_list[4].append( load("res://Modifiers/Shield/RegeneratingShield.tscn") )
	_modifier_list[4].append([3])
	
	# regenerating health: 5
	_modifier_list.append([])
	_modifier_list[5].append( load("res://Modifiers/Health/RegeneratingHealth.tscn") )
	_modifier_list[5].append([1, 3])
	
	# bigger jump: 6
	_modifier_list.append([])
	_modifier_list[6].append( load("res://Modifiers/Jump/BiggerJump.tscn") )
	_modifier_list[6].append([0])
	
	# extra jump: 7
	_modifier_list.append([])
	_modifier_list[7].append( load("res://Modifiers/Jump/ExtraJump.tscn") )
	_modifier_list[7].append([0])
	
	# extra health: 8
	_modifier_list.append([])
	_modifier_list[8].append( load("res://Modifiers/Health/ExtraHealth.tscn") )
	_modifier_list[8].append([0])




#==== Modifier Handling ====#
func get_modifier_instance(modifier_id):
	return _modifier_list[modifier_id][0].instance()

func get_modifier_types(modifier_id):
	return _modifier_list[modifier_id][1]


