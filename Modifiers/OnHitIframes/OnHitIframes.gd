extends Node

#==== Constants ====#
const _id = 0
const _modifier_ids = [1] #tick
const _name = "On Hit Invulnerability"

const _visible_time = 0.3
const _invisible_time = 0.2


#==== Components ====#
var _despawn_timer
var _timer

#==== Variables ====#
var _target 
var _needs_to_be_removed = false
var _despawn_duration # time until despawn

var _total_ticks = 2




#==== Bootstrap ====#

func initialize_values(total_ticks):
	_total_ticks = total_ticks

func initialize(target):
	_target = target
	_target.visible = false
	_target._state_manager._is_invincible = true
	
	_timer = Timer.new()
	_timer.connect("timeout", self, "on_tick")
	self.add_child(_timer)
	_timer.start(_invisible_time)

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

func on_stack(new_i_frames):
	_total_ticks = new_i_frames._total_ticks
	if _despawn_duration != null:
		initialize_timeout_timer(_despawn_duration)


func remove_modifier():
	_timer.stop()
	_target.visible = true
	_target._hurtbox.set_collision_mask_bit(2, true)
	_target._state_manager._is_invincible = false
	_timer.queue_free()
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)



#==== Specific Components ====#

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
