extends Node

# Components
var _enemy_spawner
var _enemy_container





#==== Bootstrap ====#

func initialize():
	initialize_enemy_spawner()
	_enemy_container = $EnemyContainer


func initialize_enemy_spawner():
	_enemy_spawner = $EnemySpawner
	_enemy_spawner.initialize()





#==== Logic ====#

func update_enemy_positions(speed):
	for enemy in _enemy_container.get_children():
		enemy.position.x -= speed


func add_enemy(enemy):
	_enemy_container.add_child(enemy)







