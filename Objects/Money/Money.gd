extends Node2D

#==== Constants ====#
const _type = "item"
const _usable = false #REFACTOR not implemented

#==== Variables ====#
var _id = 1
var _name = "Coin"
var _description = "A simple coin."
onready var _sprite = $Sprite.texture

var _value = 1
var _stack_limit = 50




#==== Bootstrap ====#

func initialize(id, new_name, new_description, sprite, value, stack_limit):
	_id = id
	_name = new_name
	_description = new_description
	_sprite = sprite
	$Sprite.texture = _sprite
	
	_value = value
	_stack_limit = stack_limit

# Logic

func get_type():
	return _type


func use_item(player):
	print(player)
	print("lel")


func add_to_inventory():
	var new_money = get_script().new()
	new_money._id = _id
	new_money._name = _name
	new_money._description = _description
	new_money._value = _value
	new_money._sprite = _sprite
	return new_money

