extends Node2D

# Variables

var _level_manager 
var _player
var _enemy_manager
var _ui_manager


# Bootstrap

func _init():
	initialize_enemy_manager()
	initialize_level_manager()
	inititalize_player()
	initialize_ui_manager()


func initialize_enemy_manager():
	_enemy_manager = preload("res://Enemies/EnemyManager.tscn").instance()
	add_child(_enemy_manager)
	_enemy_manager.initialize()


func initialize_level_manager():
	_level_manager = preload("res://Level/LevelManager.tscn").instance()
	add_child(_level_manager)
	_level_manager.initialize()


func inititalize_player():
	_player = preload("res://Player/Player.tscn").instance()
	_player.position = Vector2(_player.position.x+100, _player.position.y+150)
	add_child(_player)
	_player.initialize()





func initialize_ui_manager():
	_ui_manager = preload("res://UI/UIManager.tscn").instance()
	add_child(_ui_manager)
	_ui_manager.initialize()




# Logic

func update_all_node_positions(speed): # to handle the floors/player always moving
	_player.position.x -= speed
	_level_manager.update_room_positions(speed)
	_enemy_manager.update_enemy_positions(speed)







