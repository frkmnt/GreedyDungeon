extends Node

var _current_money_label
var _current_hp_label



func initialize():
	var vboxcontainer = get_child(0)
	
	var money_container = vboxcontainer.get_child(0)
	print("container ", money_container)
	_current_money_label = money_container.get_child(1)
	
	var hp_container = vboxcontainer.get_child(1)
	_current_hp_label = hp_container.get_child(1)
	update_hp_label(10)



func update_money_label(value):
	_current_money_label.text = str(value)


func update_hp_label(value):
	_current_hp_label.text = str(value)





