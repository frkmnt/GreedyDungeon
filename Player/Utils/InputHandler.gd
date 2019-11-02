extends Node


var directional_input_buffer = [] #takes string identifiers as the parameters
var action_input_buffer = []

var directional_input = ""
var action_input = ""
var final_input = ""




#measured in frames
var input_up
var input_down 
var input_left 
var input_right

var input_jump 
var input_attack
var input_skill


enum ACTION_TYPES {
NEUTRAL,
JUMP,
UP_ATTACK,
DOWN_ATTACK,
SIDE_ATTACK,
NEUTRAL_ATTACK,
UP_SKILL,
DOWN_SKILL,
SIDE_SKILL
NEUTRAL_SKILL
}






func _init():
	input_up = 0
	input_down = 0
	input_left = 0
	input_right = 0
	input_jump = 0
	input_attack = 0
	input_skill = 0
	



func process_all_inputs():
	input_up = assign_input_to_buffer("up", input_up, directional_input_buffer)
	input_down = assign_input_to_buffer("down", input_down, directional_input_buffer)
	input_left = assign_input_to_buffer("left", input_left, directional_input_buffer)
	input_right = assign_input_to_buffer("right", input_right, directional_input_buffer)
	
	input_jump = assign_input_to_buffer("jump", input_jump, action_input_buffer)
	input_attack = assign_input_to_buffer("attack", input_attack, action_input_buffer)
	input_skill = assign_input_to_buffer("skill", input_skill, action_input_buffer)
	
	directional_input = get_input_from_buffer(directional_input_buffer)
	action_input = get_input_from_buffer(action_input_buffer)
	find_final_input()




func assign_input_to_buffer(identifier, input, buffer):
	var updated_input_value = input
	var is_input_pressed = Input.is_action_pressed(identifier)
	
	if is_input_pressed:
		updated_input_value += 1
		if not buffer.has(identifier): #neutral
			buffer.push_front(identifier)

	else:
		if buffer.has(identifier):
			if updated_input_value == -1:
				var input_position = buffer.find(identifier)
				buffer.remove(input_position)
				updated_input_value = 0
			else:
				updated_input_value = -1
	
	return updated_input_value




func find_final_input():
	var aux_final_input = ""
	
	aux_final_input += directional_input
	if action_input != "" and directional_input != "":
		aux_final_input += "_"
	
	aux_final_input += action_input
	
	if aux_final_input == "":
		final_input = "neutral"
	else:
		final_input = aux_final_input




func get_input_from_buffer(buffer):
	var input = ""
	if buffer.size() > 0:
		input = buffer[0]
	return input





