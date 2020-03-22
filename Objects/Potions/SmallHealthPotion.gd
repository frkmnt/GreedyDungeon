extends Node2D


var _type = "item"
var _id = 10
var _name = "Small Health Potion"
var _description = "A small potion that recovers 2 HP." 
onready var _sprite = $Sprite.texture

var _value = 30
var _stack_limit = 3




# Bootstrap

func initialize(id, name, description, sprite, value, stack_limit):
	_id = id
	_name = name
	_description = description
	_sprite = $Sprite.texture
	_sprite = sprite
	_value = value
	_stack_limit = stack_limit



# Logic
func get_type():
	return _type



func use_item(player):
	player.add_hp(2)


func add_to_inventory():
	var new_potion = get_script().new()
	new_potion._id = _id
	new_potion._name = _name
	new_potion._description = _description
	new_potion._value = _value
	new_potion._sprite = _sprite
	return new_potion
	





