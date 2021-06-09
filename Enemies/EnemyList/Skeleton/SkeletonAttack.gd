extends Node

const _TYPE = "damage"
const _knockback_force = Vector2(8000, -5000)

var _damage = 1
var _modifiers = []

func get_type():
	return _TYPE
