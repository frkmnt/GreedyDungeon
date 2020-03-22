extends Node

#==== Variables ====#
var _id = "neutral_ground"
var _type = "normal"

export (Vector2) var _knockback = Vector2(0,0)
export (int) var _damage = 0



func get_type():
	return _type
