extends Node2D

const _TYPE = "powerup"


func get_type():
	return _TYPE


func player_touched_powerup(player):
	player._max_jumps += 1
	queue_free()