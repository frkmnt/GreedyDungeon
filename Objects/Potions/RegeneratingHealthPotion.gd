extends Sprite

#==== Components ====#
var _object_data 


#==== Bootstrap ====#

func initialize(object_data):
	var type = "item"
	var id = 20
	var name = "Regenating Health Potion"
	var description = "This potion restores 5 hp every 10 seconds, for 1 minute." 
	var value = 150
	var stack_limit = 2
	_object_data = object_data
	_object_data.initialize(type, id, name, description, value, stack_limit, texture)


#==== Logic ====#
func use_item(player):
	var modifier_manager = player._overseer._modifier_manager
	var regenerating_health = modifier_manager.get_modifier_instance(5)
	regenerating_health.initialize_values(5, 10)
	var was_added = player._state_manager.add_modifier(regenerating_health)
	if was_added:
		regenerating_health.initialize_timeout_timer(60.1)


func get_new_instance():
	var new_instance = get_script().new()
	new_instance._object_data = _object_data
	return new_instance








