extends Control

#==== Variables ====#
var _parent



#==== Bootstrap ====#

func initialize(parent):
	_parent = parent


func on_click():
	_parent.on_jump_button_click()



