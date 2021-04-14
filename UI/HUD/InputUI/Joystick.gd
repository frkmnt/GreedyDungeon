extends Node2D

#==== Variables ====#

var _handle 
const _joystick_radius = (300 * 0.2) + 20 # radius * scale + handle width
const _click_radius = (300 * 0.2) # radius * scale



#==== Bootstrap ====#

func initialize():
	_handle = $Handle 



#==== Handle Input ====#

func move_joystick_to_location(new_pos):
	position = new_pos

func set_gesture_on_joystick(swipe): # converts a swipe to a position for the handle
	swipe *= 0.1
	var new_pos_vector = _handle.position + swipe
	if new_pos_vector.length() <= _joystick_radius: # if the handle hasn't reached the max position
		_handle.position += swipe
	else:
		var vector_to_radius_ratio = _joystick_radius / swipe.length()
		_handle.position = swipe * vector_to_radius_ratio

func reset_handle_pos():
	_handle.position = Vector2(0, 0)

func is_within_bounds(pos): # check if the position (usually a screen touch) is within the bounds
	var is_within_bounds = false
	if position.distance_to(pos) <= _click_radius:
		is_within_bounds = true
	return is_within_bounds 
