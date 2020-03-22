extends Node

#==== Components ====#
var _enemy_spawner
var _enemy_container


#==== Variables ====#
var _despawn_pos_x = -1000
var _despawn_pos_y = 170





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
		enemy.position.x += speed


func add_enemy(enemy):
	_enemy_container.add_child(enemy)


func update_enemy_despawn_positions():
	for enemy in _enemy_container.get_children():
		enemy.update_despawn_position(_despawn_pos_x)


#==== Level Manager Interface ====#

func update_despawn_position(new_pos):
	_despawn_pos_x = new_pos
	update_enemy_despawn_positions()




