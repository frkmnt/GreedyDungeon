extends Node

#==== Variables ====#
var _damage = 1
var _knockback = Vector2(0,0)
var _modifiers = []


#==== Bootstrap ====#

func _init(damage, knockback, modifiers):
	_damage = damage
	_knockback = knockback
	_modifiers = modifiers

