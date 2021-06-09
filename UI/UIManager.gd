extends Node

#==== Components ====#
var _hud_manager
var _camera
var _inventory_panel
var _enable_inventory_button



#==== Bootstrap ====#

func initialize():
	_hud_manager = $CanvasLayer/HUD
	_hud_manager.initialize(self)
	_camera = $Camera
	_inventory_panel = $CanvasLayer/InventoryPanel
	_inventory_panel.initialize(self)
	_enable_inventory_button = $CanvasLayer/EnableInventoryButton
	_enable_inventory_button.initialize(self)

func initialize_input_ui_player(player): # the HudManager's TouchInputManager
	_hud_manager.initialize_components_with_player(player)


#==== UI Interaction ====#

func update_money_value(value):
	_hud_manager.update_money_label(value)

func update_cur_hp_value(value):
	_hud_manager.update_cur_hp(value)

func update_max_hp_value(value):
	_hud_manager.update_max_hp(value)


func enable_inventory():
	_inventory_panel.toggle_visibility() # TODO also add to player TAB input
	
func disable_inventory():
	_inventory_panel.toggle_visibility()
	_enable_inventory_button.visible = true
