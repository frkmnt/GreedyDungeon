extends Node



#==== Constants ====#
const _id = 2
const _modifier_ids = [0] # passive 
const _name = "Extra Jump"
const _description = "Increases the number of jumps."

#==== References ====#
var _target 


#==== Variables ====#
var _needs_to_be_removed = false

var _extra_jumps = 1



#==== Bootstrap ====#

func initialize_values(extra_jumps):
	_extra_jumps = extra_jumps


func initialize(target):
	_target = target
	_target._state_manager._max_jumps += _extra_jumps




#==== Stack Handling ====#
func on_stack(new_extra_jumps):
	_extra_jumps += new_extra_jumps
	_target._state_manager._max_jumps += new_extra_jumps



#==== On Tick ====#

func end_modifier():
	_target._state_manager._max_jumps -= _extra_jumps
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


