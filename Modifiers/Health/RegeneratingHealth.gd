extends Node2D


#==== Constants ====#
const _id = 5
const _modifier_ids = [1, 3] # tick
const _name = "Regenerating Health"
const _description = "Heals 1 HP every 10 seconds, if you don't receive damage." #refactor change qty
const _priority = 10

#==== References ====#
var _modifier_manager
var _target 

#==== Components ====#
var _timer

#==== Variables ====#
var _needs_to_be_removed = false # not needed, self removal

var _health_regen = 1
var _tick_time = 3





#==== Bootstrap ====#

func initialize_values(health_regen, tick_time):
	_health_regen = health_regen
	_tick_time = tick_time

func initialize(target):
	_target = target
	_modifier_manager = target.get_tree().get_root().get_child(0)._modifier_manager
	start_timer()



#==== Stack Handling ====#
func on_stack(new_regenerating_health):
	if new_regenerating_health._tick_time < _tick_time:
		_tick_time = new_regenerating_health._tick_time
	if new_regenerating_health._health_regen < _health_regen:
		_health_regen = new_regenerating_health._health_regen



func start_timer():
	_timer = Timer.new()
	_timer.connect("timeout", self, "on_tick")
	_timer.set_one_shot(true)
	self.add_child(_timer)
	_timer.start(_tick_time)



#==== Receive Attack ====#

func on_receive_attack(attack):
	_timer.start(_tick_time)
	return attack



#==== Tick ====#

func on_tick():
	_timer.stop()
	_target.add_hp(_health_regen)
	_timer.start(_tick_time)



