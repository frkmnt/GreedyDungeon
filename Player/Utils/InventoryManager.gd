extends Node

#==== Components ====#
var _inventory_panel


#==== Variables ====#

var _item_list = [] # contains lists of [item, qty]
var _stacking_map = {} # contains item_id : [available positions], 0 is free space
var _max_items
var _is_inventory_full = false


#==== Equipment ====#
var _head = null
var _chest = null
var _legs = null
var _shoes = null

var _weapon = null


#==== Bootstrap ====#

func initialize(inventory_panel):
	_inventory_panel = inventory_panel
	_max_items = 36
	var inventory_space
	for index in range(0, _max_items): # initialize item list
		inventory_space = [null, 0]
		_item_list.append([null, 0])






#==== Item Management ====#

func add_item(item):
	if not _is_inventory_full:
		var item_data = item._object_data
		var item_positions = _stacking_map.get(item_data._id)
#		print("item id ", item_data._id)
#		print("item name ", item_data._name)
		if not item_positions == null: # item exists
			for pos in item_positions:
				if _item_list[pos][1] < item_data._stack_limit:
					#print("adding to stack ", item_data._name, ", ", _item_list[pos][1])
					_item_list[pos][1] += 1
					_inventory_panel.update_item_amount_in_label(_item_list[pos][1], pos)
					item.queue_free()
					return true
			var first_empty_pos = find_first_empty_slot() # stacks are full
			if not first_empty_pos == -1:
				#print("new stack of ", item_data._name)
				_item_list[first_empty_pos] = [item, 1]
				item_positions.append(first_empty_pos)
				_inventory_panel.add_item_to_slot(item_data, first_empty_pos)
				item.queue_free()
				return true
			else:
				return false
				#print("inventory full!!")
			
		else:
			var first_empty_pos = find_first_empty_slot()
			if not first_empty_pos == -1:
				#print("new stack of ", item_data._name)
				var new_instance = item.get_new_instance()
				item_data = new_instance._object_data
				_item_list[first_empty_pos] = [new_instance, 1]
				_stacking_map[item_data._id] = [first_empty_pos]
				_inventory_panel.add_item_to_slot(item_data, first_empty_pos)
				item.queue_free()
				return true
			else:
				return false
				#print("inventory full!!")



func find_first_empty_slot():
	for index in range(_item_list.size()):
		if _item_list[index][0] == null:
			return index
	
	_is_inventory_full = true
	return -1


func drop_stack(position):
	_is_inventory_full = false
	var item_id = _item_list[position][0]._object_data._id
	var stack_info = _stacking_map.get(item_id)
	stack_info.remove(stack_info.find(position))
	if stack_info.size() == 0:
		_stacking_map.erase(item_id)
	_inventory_panel.remove_item_image_from_slot(position)
	_item_list[position] = [null, 0]


func remove_item_from_slot(position):
	_item_list[position][1] -= 1
	_inventory_panel.update_item_amount_in_label(_item_list[position][1], position)
	if _item_list[position][1] == 0:
		drop_stack(position)


func toggle_visibility():
	_inventory_panel.toggle_visibility()
	











