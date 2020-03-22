extends Node

#==== Components ====#

var _player
var _inventory


#==== Variables ====#

var _items_panel
var _equipment_panel
var _info_label
var _use_button 

var _currently_selected_slot




#==== Bootstrap ====#

func initialize():
	_items_panel = $ItemsPanel
	_equipment_panel = $EquipmentPanel
	_info_label = $InfoPanel/InfoLabel
	_use_button = $InfoPanel/UseButton
	
	_currently_selected_slot = -1
	
	var current_button
	for index in range(0, _items_panel.get_child_count()): # initialize buttons
		current_button = _items_panel.get_child(index)
		current_button.connect("button_down", self, "on_slot_pressed", [index])


func _ready():
	var player_group_objects = get_tree().get_nodes_in_group("Player")
	_player = player_group_objects[0]
	_inventory = _player._inventory





#=== UI ===

func add_item_to_slot(item, slot_index):
	var slot = _items_panel.get_child(slot_index)
	slot.icon = item._sprite
	var slot_amount_label = slot.get_child(0)
	slot_amount_label.text = str (1)


func remove_item_image_from_slot(slot_index):
	_use_button.visible = false
	_info_label.text = ""
	var slot = _items_panel.get_child(slot_index)
	slot.icon = null
	var slot_amount_label = slot.get_child(0)
	slot_amount_label.text = str (0)


func update_item_amount_in_label(quantity, slot_index):
	var slot = _items_panel.get_child(slot_index)
	var slot_amount_label = slot.get_child(0)
	slot_amount_label.text = str (quantity)

func decrement_item_amount_in_slot(quantity, slot_index):
	var slot = _items_panel.get_child(slot_index)
	var slot_amount_label = slot.get_child(0)
	slot_amount_label.text = str (quantity)




func on_slot_pressed(slot_id): 
	var slot_item = _inventory._item_list[slot_id][0]
	if not slot_item == null:
		_info_label.text = slot_item._description
		_currently_selected_slot = slot_id
		if slot_item.has_method("use_item"):
			_use_button.visible = true
	else:
		_info_label.text = ""


func _on_inventory_panel_hide():
	_info_label.text = ""
	_currently_selected_slot = -1
	_use_button.visible = false
	


func use_item_on_slot():
	var slot_item = _inventory._item_list[_currently_selected_slot][0]
	slot_item.use_item(_player)
	_inventory.remove_item_from_slot(_currently_selected_slot)



func toggle_visibility():
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true










