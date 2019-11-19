extends Node

const _TYPE = "powerup"


func get_type():
	return _TYPE


func player_touched_powerup(player):
	player.increase_max_hp(1)
	queue_free()