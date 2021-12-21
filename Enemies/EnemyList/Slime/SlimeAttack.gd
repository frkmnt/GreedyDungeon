extends Node

#==== Variables ====#
var _knockback_force = Vector2(5500, 0)

var _damage = 1
var _damage_range = [5,10]

var _crit_chance = 10
var _crit_damage_range = [11,15]

var _modifiers = []

var _poison_prefab 


#==== Bootstrap ====#
func _init():
	_poison_prefab = load("res://Modifiers/Poison/Poison.tscn")
	var poison_instance = create_poison_instance()
	_modifiers.append(poison_instance)

	var crit_roll = rand_range(0, 100)
	if crit_roll <= _crit_chance:
		_damage = floor(rand_range(_crit_damage_range[0], _crit_damage_range[1]))
	else:
		_damage = floor(rand_range(_damage_range[0], _damage_range[1]))


func create_poison_instance():
	var poison_instance = _poison_prefab.instance()
	poison_instance.initialize_values(2, 5, 3)
	return poison_instance
	return poison_instance
