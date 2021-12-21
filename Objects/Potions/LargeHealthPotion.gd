extends Sprite

#==== Components ====#
var _object_data 


#==== Bootstrap ====#

func initialize(object_data):
	var type = "item"
	var id = 16
	var name = "Large Health Potion"
	var description = "A potion that instantly restores 25 HP." 
	var value = 75
	var stack_limit = 2
	_object_data = object_data
	_object_data.initialize(type, id, name, description, value, stack_limit, texture)


#==== Logic ====#

func use_item(player):
	player.add_hp(25)


func get_new_instance():
	var new_instance = get_script().new()
	new_instance._object_data = _object_data
	return new_instance



