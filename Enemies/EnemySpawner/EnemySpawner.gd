extends Node2D


var _enemy_prefabs = []

var _skeleton




func initialize():
	_skeleton = preload("res://Enemies/EnemyList/Skeleton/Skeleton.tscn")
	_enemy_prefabs.append(_skeleton)



func get_random_enemy():
	randomize()
	var random_enemy_index = floor(rand_range(0, _enemy_prefabs.size()))
	print("Spawning Enemy ", random_enemy_index+1, ".")
	return _enemy_prefabs[random_enemy_index]





