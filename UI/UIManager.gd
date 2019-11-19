extends Node

# Components
var _hud_manager
var _camera # The camera is static, the world moves backward


func initialize():
	_hud_manager = get_child(0)
	_hud_manager.initialize()


func update_money_value(value):
	_hud_manager.update_money_label(value)


func update_hp_value(value):
	_hud_manager.update_hp_label(value)

