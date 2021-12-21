extends Node

const _knockback_force = Vector2(13000, -7000)

var _damage = 1
var _crit_chance = 15

var _damage_range = [10,15]
var _crit_damage_range = [20,25]
var _modifiers = []

func _init():
	var crit_roll = rand_range(0, 100)
	if crit_roll <= _crit_chance:
		_damage = floor(rand_range(_crit_damage_range[0], _crit_damage_range[1]))
	else:
		_damage = floor(rand_range(_damage_range[0], _damage_range[1]))



