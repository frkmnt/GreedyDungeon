extends Node2D

#==== References ====#
var _loot_manager

#==== Variables ====#
var _enemy_prefabs = []

var _skeleton
var _slime


#==== Bootstrap ====#

func initialize():
	_skeleton = preload("res://Enemies/EnemyList/Skeleton/Skeleton.tscn")
	_enemy_prefabs.append(_skeleton)
	
	_slime = preload("res://Enemies/EnemyList/Slime/Slime.tscn")
	_enemy_prefabs.append(_slime)

func initialize_with_loot_manager(loot_manager):
	_loot_manager = loot_manager



#==== Logic ====#

func get_random_enemy():
	randomize()
	var random_enemy_index = floor(rand_range(0, _enemy_prefabs.size()))
	#print("Spawning Enemy ", random_enemy_index+1, ".")
	var enemy = _enemy_prefabs[random_enemy_index].instance()
	var enemy_loot = _loot_manager.spawn_low_level_enemy_loot()
	enemy.initialize_pickable_object(enemy_loot)
	return enemy





