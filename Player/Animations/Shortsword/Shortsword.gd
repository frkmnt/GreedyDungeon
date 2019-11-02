extends Node2D

var _hero_manager
var _animation_player

var _attack


func inititialize():
	_hero_manager = get_parent().get_parent()
	_animation_player = _hero_manager._animator
	_attack = preload("res://Utils/Attack.gd").new()


# GROUND

func neutral_ground():
	_animation_player.play("shortsword_neutral_ground")
	_attack._damage = 1
	_attack._knockback = Vector2(130, 0)

func up_ground():
	_animation_player.play("shortsword_up_ground")
	_attack._damage = 1
	_attack._knockback = Vector2(50, -225)

func down_ground():
	_animation_player.play("shortsword_down_ground")
	_attack._damage = 1
	_attack._knockback = Vector2(0, 50)

func side_ground():
	_animation_player.play("shortsword_side_ground")
	_attack._damage = 1
	_attack._knockback = Vector2(90, 0)



# AIR

func neutral_air():
	_animation_player.play("shortsword_neutral_air")
	_attack._damage = 1
	_attack._knockback = Vector2(75, 0)

func up_air():
	_animation_player.play("shortsword_up_air")
	_attack._damage = 1
	_attack._knockback = Vector2(25, -200)


func down_air():
	_hero_manager._velocity.y = 200
	_animation_player.play("shortsword_down_air")
	_attack._damage = 1
	_attack._knockback = Vector2(75, 75)



func side_air():
	_animation_player.play("shortsword_side_air")
	_attack._damage = 1
	_attack._knockback = Vector2(50, 0)





