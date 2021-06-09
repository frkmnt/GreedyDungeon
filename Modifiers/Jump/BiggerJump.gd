extends Node



#==== Constants ====#
const _id = 2
const _modifier_ids = [0] # passive 
const _name = "Bigger Jump"
const _description = "Increases jump height."

#==== References ====#
var _target 

#==== Components ====#
var _despawn_timer

#==== Variables ====#
var _needs_to_be_removed = false
var _despawn_duration # time until despawn

var _extra_jump_force = 1



#==== Bootstrap ====#

func initialize_values(extra_jump_force):
	_extra_jump_force = extra_jump_force

func initialize(target):
	_target = target
	_target._state_manager._jump_force -= _extra_jump_force

func initialize_timeout_timer(duration):
	if not is_instance_valid(_despawn_timer):
		_despawn_duration = duration
		_despawn_timer = Timer.new()
		_despawn_timer.connect("timeout", self, "remove_modifier")
		_despawn_timer.set_one_shot(true)
		add_child(_despawn_timer)
		_despawn_timer.start(duration)
	else:
		if _despawn_timer.get_time_left() < duration:
			_despawn_timer.start(duration)



#==== Common Components ====#

func on_stack(new_extra_jump_force):
	_extra_jump_force += new_extra_jump_force
	_target._state_manager._jump_force -= new_extra_jump_force
	if _despawn_duration != null:
		initialize_timeout_timer(_despawn_duration)

func remove_modifier():
	_target._state_manager._jump_force += _extra_jump_force
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


