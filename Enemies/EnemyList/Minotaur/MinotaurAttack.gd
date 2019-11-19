extends Node

const _TYPE = "damage"

export var _knockback_force = Vector2(1000, 0)
export var _damage = 1

func get_type():
	return _TYPE
