extends Node

#==== References ====#
var _parent_menu

#==== Components ====#
var _health_bar_label



#==== Bootstrap ====#

func initialize():
	_health_bar_label = $TotalHealthLabel

func initialize_with_player(player):
	self.max_value = player._state_manager._max_hp
	self.value = player._state_manager._current_hp
	update_health_label()

#==== UI Interaction ====#

func set_max_health(max_health):
	self.max_value = max_health
	update_health_label()
	
func set_cur_health(cur_health):
	self.value = cur_health
	update_health_label()

func update_health_label():
	var text = str(self.value) + " / " + str(self.max_value)
	_health_bar_label.text = text
