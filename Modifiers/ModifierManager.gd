extends Node2D

#==== Modifier IDs ====#
# on hit i-frames        0
# poison                 1
# luck                   2
# shield                 3
# regenerating shield    4
# regenerating health    5

#==== Modifier Types ====#
# passive                0
# tick                   1
# delayed                2
# received_hit           3
# condition              4





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


#==== Modifier Handling ====#
func get_modifier_instance(modifier_id):
	return _modifier_list[modifier_id][0].instance()

func get_modifier_types(modifier_id):
	return _modifier_list[modifier_id][1]


