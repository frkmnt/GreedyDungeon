extends Node

const _TYPE = "powerup"


func get_type():
	return _TYPE


func player_touched_powerup(player):
	var money_generator = get_tree().root.get_child(0). \
		_level_manager._map_generator._money_generator
	money_generator._money_modifier += 2
	queue_free()


