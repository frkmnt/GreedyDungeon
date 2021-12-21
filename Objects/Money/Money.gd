extends Node2D

#==== Comments ====#
# This is the only object the player can pick up that has its own collision box.
# All other object are bound to a parent object that controls the shape of the hitbox.

#==== Components ====#
var _object_data
var _collision_shape

#==== Constants ====#
const _type = "money"


#==== Bootstrap ====#

func initialize(id, name, description, sprite, value, stack_limit, object_data):
	_object_data = object_data
	_object_data.initialize(_type, id, name, description, value, stack_limit, sprite)
	$Sprite.texture = sprite
	_collision_shape = $CollisionShape2D


#==== Logic ====#

func get_new_instance():
	var new_instance = get_script().new()
	new_instance._object_data = _object_data
	return new_instance


