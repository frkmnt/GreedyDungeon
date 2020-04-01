extends Node

const _TYPE = "damage"
const _knockback_force = Vector2(8000, 0)

var _damage = 1
var _modifiers = []

func get_type():
	return _TYPE



func on_hitbox_entered(player_hurtbox):
	player_hurtbox.get_parent().receive_attack(duplicate(4), get_parent().position)
