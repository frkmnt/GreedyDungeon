extends Node

const _TYPE = "damage"

export var _damage = 1
export var _knockback_force = Vector2(1000, 0)
var _modifiers = []

func get_type():
	return _TYPE



func set_attack1_values():
	_damage = 1
	_knockback_force = Vector2(17000, -13000)


func set_attack2_values():
	_damage = 1
	_knockback_force = Vector2(20000, -5000)


func set_attack3_values():
	_damage = 1
	_knockback_force = Vector2(9000, 0)





func on_hitbox_entered(player_hurtbox):
	player_hurtbox.get_parent().receive_attack(duplicate(4), get_parent().position)
