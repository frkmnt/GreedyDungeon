extends Node2D

#==== References ====#
var _level_manager 
var _player
var _enemy_manager
var _ui_manager
var _modifier_manager


#==== Bootstrap ====#

func _init():
	initialize_enemy_manager()
	initialize_ui_manager()
	initialize_level_manager()
	initialize_modifier_manager()
	inititalize_player()


func initialize_enemy_manager():
	_enemy_manager = preload("res://Enemies/EnemyManager.tscn").instance()
	add_child(_enemy_manager)
	_enemy_manager.initialize()

func initialize_level_manager():
	_level_manager = preload("res://Level/LevelManager.tscn").instance()
	add_child(_level_manager)
	_level_manager.initialize()
	_enemy_manager.initialize_with_loot_manager(_level_manager._loot_generator)
	_level_manager.spawn_starter_rooms()

func initialize_modifier_manager():
	_modifier_manager = preload("res://Modifiers/ModifierManager.tscn").instance()
	add_child(_modifier_manager)
	_modifier_manager.initialize()

func inititalize_player():
	_player = preload("res://Player/Player.tscn").instance()
	_player.position = Vector2(_player.position.x+100, _player.position.y+150)
	add_child(_player)
	_player.initialize()
	_ui_manager.initialize_input_ui_player(_player)

func initialize_ui_manager():
	_ui_manager = preload("res://UI/UIManager.tscn").instance()
	add_child(_ui_manager)
	_ui_manager.initialize()
