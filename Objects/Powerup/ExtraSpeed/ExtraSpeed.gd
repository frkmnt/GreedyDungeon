extends Node

const _TYPE = "powerup"


func get_type():
	return _TYPE


func player_touched_powerup(player):
	player.increase_movement_speed(15)
	queue_free()