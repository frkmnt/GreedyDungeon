extends Node

#==== Variables ====#
var _knockback_force = Vector2(5500, 0)
var _damage = 1
var _modifiers = []

var _poison_prefab 


#==== Bootstrap ====#
func initialize():
	_poison_prefab = load("res://Modifiers/Poison/Poison.tscn")
	var poison_instance = create_poison_instance()
	_modifiers.append(poison_instance)

func create_poison_instance():
	var poison_instance = _poison_prefab.instance()
	poison_instance.initialize_values(2, 1, 2)
	return poison_instance
	return poison_instance
