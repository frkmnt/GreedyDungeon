extends Node2D


const _TYPE = "money"

var _value = 1




# Bootstrap

func initialize(value, sprite):
	var _sprite = $Sprite
	_sprite.texture = sprite
	_value = value


# Logic

func get_type():
	return _TYPE

func player_touched_money(player):
	player._current_money += _value
	queue_free()