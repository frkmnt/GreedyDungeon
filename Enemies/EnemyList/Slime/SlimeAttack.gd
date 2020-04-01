extends Node

#==== Variables ====#
var _knockback_force = Vector2(5500, 0)
var _damage = 1
var _modifiers = []

var _poison_prefab 


#==== Bootstrap ====#
func initialize():
	_poison_prefab  = load("res://Modifiers/Poison/Poison.tscn")

func create_poison_instance():
	var poison_instance = _poison_prefab.instance()
	poison_instance.initialize_values(2, 1, 2)
	return poison_instance

func on_hitbox_entered(player_hurtbox):
	var new_attack = duplicate(4)
	var poison_instance = create_poison_instance()
	new_attack._modifiers.append(poison_instance)
	player_hurtbox.get_parent().receive_attack(new_attack, get_parent().position)
