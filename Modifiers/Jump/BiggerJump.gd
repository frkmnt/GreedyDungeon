extends Node



#==== Constants ====#
const _id = 2
const _modifier_ids = [0] # passive 
const _name = "Bigger Jump"
const _description = "Increases jump height."

#==== References ====#
var _target 


#==== Variables ====#
var _needs_to_be_removed = false

var _extra_jump_force = 1



#==== Bootstrap ====#

func initialize_values(extra_jump_force):
	_extra_jump_force = extra_jump_force


func initialize(target):
	_target = target
	_target._state_manager._jump_force -= _extra_jump_force




#==== Stack Handling ====#
func on_stack(new_extra_jump_force):
	_extra_jump_force += new_extra_jump_force
	_target._state_manager._jump_force -= new_extra_jump_force



#==== On Tick ====#

func end_modifier():
	_target._state_manager._jump_force += _extra_jump_force
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


