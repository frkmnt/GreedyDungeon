extends Node

#==== Variables ====#
var _knockback_force = Vector2(5500, 0)
var _damage = 1
var _modifiers = []

var _poison_prefab 


#==== Bootstrap ====#
func initialize():
	_poison_prefab  = load("res://Modifiers/Poison.gd")





func on_hitbox_entered(player_hurtbox):
	var poison_modifier = _poison_prefab.new()
	poison_modifier.initialize_damage(2, 1, 2)
	_modifiers.append(poison_modifier)
	player_hurtbox.get_parent().receive_attack(self, get_parent().position)
