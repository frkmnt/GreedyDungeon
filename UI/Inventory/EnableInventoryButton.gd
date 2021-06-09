extends Button

#==== References ====#
var _parent_menu


#==== Bootstrap ====#

func initialize(parent_menu):
	_parent_menu = parent_menu


#==== Logic ====#

func enable_inventory():
	_parent_menu.enable_inventory()
	visible = false
