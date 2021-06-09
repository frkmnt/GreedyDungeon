extends Node2D


#==== Constants ====#
const _id = 4
const _modifier_ids = [3] # received_hit
const _name = "Regenerating Shield"
const _description = "Creates a shield every 10 seconds" #refactor change qty
const _priority = 1

#==== References ====#
var _modifier_manager
var _target 

#==== Components ====#
var _despawn_timer
var _timer

#==== Variables ====#
var _needs_to_be_removed = false # not needed, self removal
var _despawn_duration # time until despawn

var _respawn_time = 15



#==== Bootstrap ====#

func initialize_values(respawn_time):
	_respawn_time = respawn_time

func initialize(target):
	_target = target
	_modifier_manager = target.get_tree().get_root().get_child(0)._modifier_manager
	start_timer()

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

func on_stack(new_regenerating_shield):
	if new_regenerating_shield._respawn_time < _respawn_time:
		_respawn_time = new_regenerating_shield._respawn_time
	if _despawn_duration != null:
		initialize_timeout_timer(_despawn_duration)

func remove_modifier():
	_target._hurtbox.set_collision_mask_bit(2, true)
	_timer.queue_free()
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


#==== Specific Components ====#
func on_receive_attack(attack):
	start_timer()
	return attack

func on_tick():
	_timer.queue_free()
	if not _target._state_manager.get_modifier(3):
		var _shield_instance = _modifier_manager.get_modifier_instance(3)
		_target._state_manager.add_modifier(_shield_instance)


func start_timer():
	if not is_instance_valid(_timer):
		_timer = Timer.new()
		_timer.connect("timeout", self, "on_tick")
		_timer.set_one_shot(true)
		self.add_child(_timer)
		_timer.start(_respawn_time)
	else:
		_timer.start(_respawn_time)








