extends Node

#==== Components ====#
var _hud_manager
var _camera # The camera is static, the world moves backward
var _inventory_panel



#==== Bootstrap ====#

func initialize():
	_hud_manager = $CanvasLayer/HUD
	_hud_manager.initialize()
	_camera = $Camera
	_inventory_panel = $CanvasLayer/InventoryPanel
	_inventory_panel.initialize()

func initialize_input_ui_player(player): # the HudManager's TouchInputManager
	_hud_manager.initialize_input_ui_player(player)


func update_money_value(value):
	_hud_manager.update_money_label(value)


func update_hp_value(value):
	_hud_manager.update_hp_label(value)

