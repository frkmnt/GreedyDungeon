extends Node2D

#==== References ====#
var _loot_manager

#==== Variables ====#
var _enemy_prefabs = []

var _skeleton
var _skeleton_white
var _skeleton_mace
var _slime
var _ghost


#==== Bootstrap ====#

func initialize():
#	_skeleton_white = preload("res://Enemies/EnemyList/SkeletonWhite/SkeletonWhite.tscn")
#	_enemy_prefabs.append(_skeleton_white)
#
	_skeleton = preload("res://Enemies/EnemyList/Skeleton/Skeleton.tscn")
	_enemy_prefabs.append(_skeleton)

	_skeleton_mace = preload("res://Enemies/EnemyList/SkeletonMace/SkeletonMace.tscn")
	_enemy_prefabs.append(_skeleton_mace)

	_slime = preload("res://Enemies/EnemyList/Slime/Slime.tscn")
	_enemy_prefabs.append(_slime)

	_ghost = preload("res://Enemies/EnemyList/Ghost/Ghost.tscn")
	_enemy_prefabs.append(_ghost)

func initialize_with_loot_manager(loot_manager):
	_loot_manager = loot_manager



#==== Logic ====#

func get_random_enemy():
	randomize()
	var random_enemy_index = floor(rand_range(0, _enemy_prefabs.size()))
#	print("Spawning Enemy ", random_enemy_index+1, ".")
	var enemy = _enemy_prefabs[random_enemy_index].instance()
	var enemy_loot = get_loot_based_on_type(enemy._loot_type)
	enemy.initialize_pickable_object(enemy_loot)
	return enemy


func get_loot_based_on_type(loot_type):
	var enemy_loot
	if loot_type == 0:
		enemy_loot = _loot_manager.spawn_low_level_enemy_loot()
	elif loot_type == 1:
		enemy_loot = _loot_manager.spawn_mid_level_enemy_loot()
	else:
		enemy_loot = _loot_manager.spawn_high_level_enemy_loot()
	return enemy_loot



