extends Node

#==== Constants ====#
const _id = 0
const _modifier_ids = [1] #tick
const _name = "On Hit Invulnerability"

const _visible_time = 0.3
const _invisible_time = 0.2


#==== Components ====#
var _timer

#==== Variables ====#
var _target 

var _needs_to_be_removed = false

var _total_ticks = 2




#==== Bootstrap ====#

#REFACTOR add initialize_values

func initialize(target):
	_target = target
	_target.visible = false
	_target._state_manager._is_invincible = true
	
	_total_ticks = _target._state_manager._i_frame_ticks
	
	_timer = Timer.new()
	_timer.connect("timeout", self, "on_tick")
	_target._modifier_container.add_child(_timer)
	_timer.start(_invisible_time)



#==== Stack Handling ====#
func on_stack(new_i_frames):
	pass






#==== On Tick ====#

func on_tick():
	_timer.stop()
	_total_ticks -= 1
	if _total_ticks == 0: # disable i-frames
		remove_modifier()
	else: # handle tick
		if _total_ticks % 2 == 0:
			_target.visible = false
			_timer.start(_invisible_time)
		else:
			_target.visible = true
			_timer.start(_visible_time)




func remove_modifier():
	_timer.stop()
	_target.visible = true
	_target._hurtbox.set_collision_mask_bit(2, true)
	_target._state_manager._is_invincible = false
	_timer.queue_free()
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


