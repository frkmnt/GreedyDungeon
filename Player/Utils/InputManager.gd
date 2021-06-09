extends Node

# ==== Class Variables ====
var _parent

var _movement_input = "" # REFACTOR CURRENTLY REDUNDANT
var _movement_input_direction = 0
var _movement_frames = 0
var _stopped_movement = false

var _action_input = ""
var _action_frames = 0
var _stopped_action = false

var _inventory_input = false
var _is_mobile_mode = false # TODO create variable export
var _has_mobile_input = false # true if mobile input in this frame



#==== Bootstrap ====#

func initialize(parent):
	_parent = parent



# ==== Input Processing ==== #

func process_all_inputs():
	_inventory_input = Input.is_action_just_pressed("inventory")
	if not _is_mobile_mode:
		assign_movement_input()
		assign_action_input()
		#print(_movement_input, "\n", _action_input, "\n\n")
	else:
		if _has_mobile_input:
			_has_mobile_input = false
		else:
			_action_input = "idle"




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
	elif Input.is_action_pressed("attack_left"):
		_action_input = "left"
	elif Input.is_action_pressed("attack_right"):
		_action_input = "right"
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



#==== Handle Touch UI Inputs ====#

func reset_mobile_inputs():
	_action_input = "idle"


func assign_movement_touch(input): # called from the TouchInputManager
	if input == "left":
		_movement_input = "left"
		_movement_input_direction = -1
	elif input == "right":
		_movement_input = "right"
		_movement_input_direction = 1
	else:
		_movement_input = "neutral"
		_movement_input_direction = 0

func assign_action_touch(input): # called from the TouchInputManager
#	print("touch action: ", input) 
	_has_mobile_input = true
	var previous_action_input = _action_input
	_action_input = input
	_action_frames = 1 # TODO reconsider this, does not allow charge up attacks...
	#... could be overriden with the...
	#... TouchInputManager's _did_action_before_releasing param
	
	
