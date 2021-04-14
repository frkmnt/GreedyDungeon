extends Control

#==== References ====#
var _parent_menu
var _player

#==== Components ====#
var _joystick

#==== Variables ====#
var _is_movement_input_down = false
var _is_action_input_down = false

const _direction_array = ["right", "down", "left", "up"] # matches radian quadrants, in order
const _max_joystick_position = 612 - 90 # screen width - joystick radius
const _min_speed_for_movement = 50 # min vector speed on action swipe
const _min_speed_for_action = 50 # min vector speed on action swipe



#==== Bootstrap ====#

func initialize(parent_menu): 
	_parent_menu = parent_menu
	_joystick = $Joystick
	_joystick.initialize()
	_joystick.move_joystick_to_location(Vector2(250, 250))

func initialize_player(player):
	_player = player


#==== UI Interaction ====#

func _input(event): # InputEventGesture, get event.index for different fingers
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT: # input
		if event.position.x <= _max_joystick_position: # movement input
			handle_movement_input(event) 
		else: # action input
			handle_action_input(event)
	elif event is InputEventMouseMotion: # motion
		if event.position.x <= _max_joystick_position: # movement motion
			handle_movement_motion(event)
		else: # action motion
			handle_action_motion(event)


func handle_movement_input(event): # left side of screen
	if event.pressed: # if clicked 
		if not _is_movement_input_down and not _joystick.is_within_bounds(event.position):
			_joystick.move_joystick_to_location(event.position)
		_is_movement_input_down = true
	else: # if released
		_is_movement_input_down = false
		_joystick.reset_handle_pos()
		_player._input_handler.assign_movement_touch("idle")

func handle_movement_motion(event):
	if _is_movement_input_down:
		var swipe_vector = event.get_speed()
		_joystick.set_gesture_on_joystick(swipe_vector)
		if swipe_vector.length() >=_min_speed_for_movement:
			var direction = angle_to_direction(swipe_vector.angle())
			if not direction == "up" or not direction == "down":
				_player._input_handler.assign_movement_touch(direction)
		else:
			_player._input_handler.assign_movement_touch("idle")


func handle_action_input(event): # right side of screen
	_is_action_input_down = event.pressed
	if event.is_doubleclick():
		var action = "attack_neutral"
		_player._input_handler.assign_action_touch("idle")

func handle_action_motion(event):
	if _is_action_input_down:
		var swipe_vector = event.get_speed()
		if swipe_vector.length() >= _min_speed_for_action:
			var direction = angle_to_direction(swipe_vector.angle())
			if direction == "left" or direction == "right":
				direction = "side"
			_player._input_handler.assign_action_touch(direction)
		else:
			_player._input_handler.assign_action_touch("idle")


func angle_to_direction(angle): # accepts angles in radians
	# right ranges from 315-45, up 45-135, left 135-225, down 225-315 degrees
	var swipe_angle = rad2deg(angle)
	# adding +45 degrees to the angle causes each direction to fit into the radian quadrants
	swipe_angle += 45
	var quadrant = ceil(swipe_angle/90) # what quadrant the angle fits into
	var direction = _direction_array[quadrant-1]
	return direction



#==== Player Functions ====#

func set_movement_on_player():
	_player._input_handler


func set_action_on_player():
	_player._input_handler
