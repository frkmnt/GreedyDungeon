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


#==== Variables ====#
var _needs_to_be_removed = false

var _money_luck = 0
var _chest_luck = 0



#==== Bootstrap ====#

func initialize_values(money_luck, chest_luck):
	_money_luck = money_luck
	_chest_luck = chest_luck


func initialize(target):
	_target = target
	_money_generator = target.get_parent(). \
		_level_manager._money_generator
	
	_money_generator._money_modifier += _money_luck
	_money_generator._chest_modifier += _chest_luck




#==== Stack Handling ====#
func on_stack(new_luck):
	if new_luck._money_luck > _money_luck:
		_money_luck = new_luck._money_luck
	if new_luck._chest_luck < _chest_luck:
		_chest_luck = new_luck._chest_luck



#==== On Tick ====#

func end_modifier():
	_money_generator._money_modifier -= _money_luck
	_money_generator._chest_modifier -= _chest_luck
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


