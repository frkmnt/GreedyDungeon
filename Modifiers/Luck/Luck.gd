extends Node

#==== References ====#
var _money_generator



#==== Constants ====#
const _id = 2
const _modifier_ids = [0] # passive 
const _name = "Luck"
const _description = "Get better loot."

#==== References ====#
var _target 

#==== Components ====#
var _despawn_timer

#==== Variables ====#
var _needs_to_be_removed = false
var _despawn_duration # time until despawn

var _loot_luck = 0
var _chest_luck = 0 # TODO improve



#==== Bootstrap ====#

func initialize_values(loot_luck, chest_luck):
	_loot_luck = loot_luck
	_chest_luck = chest_luck

func initialize(target):
	_target = target
	_money_generator = target.get_parent(). \
		_level_manager._loot_generator 
	
	_money_generator.add_loot_modifier(_loot_luck)
	_money_generator.add_chest_modifier(_chest_luck)

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

func on_stack(new_luck):
	if new_luck._loot_luck > _loot_luck:
		_loot_luck = new_luck._loot_luck
	if new_luck._chest_luck < _chest_luck:
		_chest_luck = new_luck._chest_luck
	if _despawn_duration != null:
		initialize_timeout_timer(_despawn_duration)

func remove_modifier():
	_money_generator.remove_loot_modifier(_loot_luck)
	_money_generator.remove_chest_modifier(_chest_luck)
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


