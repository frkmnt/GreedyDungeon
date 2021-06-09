extends Node

#==== Constants ====#
const _id = 1
const _modifier_ids = [1] # tick
const _name = "Poison"

#==== References ====#
var _target 

#==== Components ====#
var _despawn_timer
var _timer

#==== Variables ====#
var _needs_to_be_removed = false
var _despawn_duration # time until despawn

var _total_ticks = 0
var _tick_time = 0
var _damage = 0



#==== Bootstrap ====#

func initialize_values(total_ticks, damage, tick_time):
	_total_ticks = total_ticks
	_damage = damage
	_tick_time = tick_time

func initialize(target):
	_target = target
	_timer = Timer.new()
	_timer.connect("timeout", self, "on_tick")
	self.add_child(_timer)
	_timer.start(_tick_time)

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

func on_stack(new_poison):
	if new_poison._total_ticks > _total_ticks:
		_total_ticks = new_poison._total_ticks
	if new_poison._tick_time < _tick_time:
		_tick_time = new_poison._tick_time
	if new_poison._damage > _damage:
		_damage = new_poison._damage
	if _despawn_duration != null:
		initialize_timeout_timer(_despawn_duration)


func remove_modifier():
	_timer.stop()
	_target.visible = true
	_target._hurtbox.set_collision_mask_bit(2, true)
	_timer.queue_free()
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)



#==== Specific Components ====#

func on_tick():
	_timer.stop()
	_target.lose_hp(_damage)
	
	_total_ticks -= 1
	if _total_ticks <= 0:
		remove_modifier()
	else:
		_timer.start(_tick_time)

