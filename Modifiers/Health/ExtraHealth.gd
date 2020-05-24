extends Node



#==== Constants ====#
const _id = 2
const _modifier_ids = [0] # passive 
const _name = "Extra Health"
const _description = "Increases the maximum health."

#==== References ====#
var _target 


#==== Variables ====#
var _needs_to_be_removed = false

var _extra_health = 1



#==== Bootstrap ====#

func initialize_values(extra_health):
	_extra_health = extra_health


func initialize(target):
	_target = target
	_target.increase_max_hp(_extra_health)




#==== Stack Handling ====#
func on_stack(new_extra_health):
	_extra_health += new_extra_health
	_target.increase_max_hp(_extra_health)



#==== On Tick ====#

func end_modifier():
	_target.decrease_max_hp(_extra_health)
	_needs_to_be_removed = true
	_target._state_manager.remove_modifier(self)


