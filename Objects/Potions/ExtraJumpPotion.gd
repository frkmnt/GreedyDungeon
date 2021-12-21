extends Sprite

#==== Components ====#
var _object_data 


#==== Bootstrap ====#

func initialize(object_data): 
	var type = "item"
	var id = 17
	var name = "Extra Jump Potion"
	var description = "This potion grants an extra jump for 30 seconds." 
	var value = 40
	var stack_limit = 2
	_object_data = object_data
	_object_data.initialize(type, id, name, description, value, stack_limit, texture)


#==== Logic ====#

func use_item(player):
	var modifier_manager = player._overseer._modifier_manager
	var extra_jump = modifier_manager.get_modifier_instance(7)
	var was_added = player._state_manager.add_modifier(extra_jump)
	if was_added:
		extra_jump.initialize_timeout_timer(30)


func get_new_instance():
	var new_instance = get_script().new()
	new_instance._object_data = _object_data
	return new_instance



