extends Node2D


#==== Constants ====#
const _id = 4
const _modifier_ids = [3] # passive
const _name = "Regenerating Shield"
const _description = "Creates a shield every 10 seconds" #refactor change qty
const _priority = 1

#==== References ====#
var _modifier_manager
var _target 

#==== Components ====#
var _timer

#==== Variables ====#
var _needs_to_be_removed = false # not needed, self removal

var _respawn_time = 5





#==== Bootstrap ====#

func _initialize_values(respawn_time):
	_respawn_time = respawn_time
	

func initialize(target):
	_target = target
	_modifier_manager = target.get_tree().get_root().get_child(0)._modifier_manager




#==== Stack Handling ====#
func on_stack(new_regenerating_shield):
	if new_regenerating_shield._respawn_time < _respawn_time:
		_respawn_time = new_regenerating_shield._respawn_time



#==== On Receive Hit ====#
func on_receive_attack(attack):
	var shield_info = [3, _modifier_manager.get_modifier_types(3)]
	if not _target._state_manager.has_modifier(shield_info): # shield
		_timer = Timer.new()
		_timer.connect("timeout", self, "on_tick")
		_target._modifier_container.add_child(_timer)
		_timer.start(_respawn_time)
	
	return attack



#==== Removal ====#

func on_tick():
	print("tick")
	var _shield_instance = _modifier_manager.get_modifier_instance(3)
	_target._state_manager.add_modifier(_shield_instance)


