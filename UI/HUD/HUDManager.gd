extends Node

#==== References ====#
var _parent_menu

#==== Components ====#
var _health_bar
var _input_ui_manager


#==== Bootstrap ====#

func initialize(parent_menu):
	_parent_menu = parent_menu
	_health_bar = $HealthBar
	_health_bar.initialize()
	
	_input_ui_manager = $InputUI
	_input_ui_manager.initialize(self)


func initialize_components_with_player(player):
	_input_ui_manager.initialize_with_player(player)
	_health_bar.initialize_with_player(player._state_manager._max_hp)


#==== Component Interaction ====#

func is_inventory_open():
	 return _parent_menu._inventory_panel.visible


#==== UI Interaction ====#

func update_cur_hp(value):
	_health_bar.set_cur_health(value)
	
func update_max_hp(value):
	_health_bar.set_max_health(value)


