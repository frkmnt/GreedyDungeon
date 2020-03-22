extends Node2D

#==== Components ====#
var _player_manager
var _animation_player

#==== Variables ====#
var _attack


#==== Bootstrap ====#
func initialize():
	_player_manager = get_parent()
	_animation_player = _player_manager._animator
	_attack = preload("res://Utils/Attack.gd").new()




#==== Attack Received ====#

func return_attack(): # REFACTOR add knockback as well
	if _attack._id == "down_air":
		var speed = _player_manager._velocity.y
		print(speed)
		if speed <= 12000:
			_attack._damage = 1
		elif speed <= 20000:
			_attack._damage = 2
		else:
			_attack._damage = 3
	print(_attack._damage)
	return _attack




#==== Attacks ====#

# Ground

func neutral_ground():
	_attack._id = "neutral_ground"
	_attack._damage = 1
	_attack._knockback = Vector2(130, 0)
	_animation_player.play("shortsword_neutral_ground")

func up_ground():
	_attack._id = "up_ground"
	_attack._damage = 1
	_attack._knockback = Vector2(50, -225)
	_animation_player.play("shortsword_up_ground")

func down_ground():
	_attack._id = "down_ground"
	_attack._damage = 1
	_attack._knockback = Vector2(0, 50)
	_animation_player.play("shortsword_down_ground")

func side_ground():
	_attack._id = "side_ground"
	_attack._damage = 1
	_attack._knockback = Vector2(90, 0)
	_animation_player.play("shortsword_side_ground")



# Air

func neutral_air():
	_attack._id = "neutral_air"
	_attack._damage = 1
	_attack._knockback = Vector2(75, 0)
	_animation_player.play("shortsword_neutral_air")

func up_air():
	_attack._id = "up_air"
	_attack._damage = 1
	_attack._knockback = Vector2(25, -200)
	_animation_player.play("shortsword_up_air")


func down_air():
	_player_manager._velocity.y = 5000
	_attack._id = "down_air"
	_attack._damage = 1
	_attack._knockback = Vector2(75, 75)
	_animation_player.play("shortsword_down_air")



func side_air():
	_attack._id = "side_air"
	_attack._damage = 1
	_attack._knockback = Vector2(50, 0)
	_animation_player.play("shortsword_side_air")





