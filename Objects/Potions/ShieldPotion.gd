extends Sprite

#==== Components ====#
var _object_data 


#==== Bootstrap ====#

func initialize(object_data):
	var type = "item"
	var id = 420
	var name = "Shield Potion"
	var description = "This potion grants a shield that blocks the next attack for 20 seconds. Special effects will still apply." 
	var value = 75
	var stack_limit = 2
	_object_data = object_data
	_object_data.initialize(type, id, name, description, value, stack_limit, texture)


#==== Logic ====#
func use_item(player):
	var modifier_manager = player._overseer._modifier_manager
	var shield = modifier_manager.get_modifier_instance(3)
	shield.initialize(player)
	var was_added = player._state_manager.add_modifier(shield)
	if was_added:
		shield.initialize_timeout_timer(20)


func get_new_instance():
	var new_instance = get_script().new()
	new_instance._object_data = _object_data
	return new_instance








