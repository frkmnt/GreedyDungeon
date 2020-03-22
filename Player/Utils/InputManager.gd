extends Node

# ==== Class Variables ====

var _movement_input = "" # REFACTOR CURRENTLY REDUNDANT
var _movement_input_direction = 0
var _movement_frames = 0
var _stopped_movement = false

var _action_input = ""
var _action_frames = 0
var _stopped_action = false

var _inventory_input = false






# ==== Input Processing ==== #

func process_all_inputs():
	_inventory_input = Input.is_action_just_pressed("inventory")
	if not _inventory_input:
		assign_movement_input()
		assign_action_input()
		#print(_movement_input, "\n", _action_input, "\n\n")



func assign_movement_input():
	var previous_directional_input = _movement_input
	var vertical_direction 
	
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("move_left"):
			_movement_input = "idle"
			_movement_input_direction = 0
		else:
			_movement_input = "right"
			_movement_input_direction = 1
	elif Input.is_action_pressed("move_left"):
		_movement_input = "left"
		_movement_input_direction = -1
	else:
		_movement_input = "idle"
		_movement_input_direction = 0
	
	if previous_directional_input == _movement_input:
		_movement_frames += 1
		_stopped_movement = false
	else:
		_movement_frames = 0
		_stopped_movement = true



func assign_action_input():
	var previous_action_input = _action_input
	
	if Input.is_action_pressed("jump"):
		_action_input = "jump"
	elif Input.is_action_pressed("attack_neutral"):
		_action_input = "neutral"
	elif Input.is_action_pressed("attack_side"):
		_action_input = "side"
	elif Input.is_action_pressed("attack_up"):
		_action_input = "up"
	elif Input.is_action_pressed("attack_down"):
		_action_input = "down"
	else:
		_action_input = "idle"
	
	if previous_action_input == _action_input:
		_action_frames += 1
		_stopped_action = false
	else:
		_action_frames = 0
		_stopped_action = true






