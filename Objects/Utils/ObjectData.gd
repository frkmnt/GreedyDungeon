extends Node

#==== Variables ====#
var _type = "item"
var _id = -1
var _name = "Generic Object"
var _description = "Use this as a holder for an object's data." 
var _value = 0
var _stack_limit = 1
var _sprite = null




#==== Bootstrap ====#

# TODO may need to be swapped with a setter for each param
func initialize(type, id, name, description, value, stack_limit, sprite):
	_type = type
	_id = id
	_name = name
	_description = description
	_value = value
	_stack_limit = stack_limit
	_sprite = sprite



#==== Logic ====#
func get_type():
	return _type


func get_sprite():
	return _sprite

