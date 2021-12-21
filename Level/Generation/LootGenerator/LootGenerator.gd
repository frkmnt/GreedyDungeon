extends Node2D

#==== Comments ====#
# The main class that deals with loot generation.
# From here, more specific types of loot generators are called to
# randomize content for specific situations, such as defeating an enemy
# or breaking a chest.


#==== Components ====#
var _money_generator = preload("res://Level/Generation/LootGenerator/MoneyGenerator.gd").new()
var _potion_generator = preload("res://Level/Generation/LootGenerator/PotionGenerator.gd").new()
var _weapon_generator = preload("res://Level/Generation/LootGenerator/WeaponGenerator.gd").new()


#==== Constants ====#
const _OBJECT_DATA_PREFAB = preload("res://Objects/Utils/ObjectData.gd")


#==== Prefabs ====#
const _CHEST_PREFAB = preload("res://Objects/Chest/Chest.tscn")






#==== Variables ====#
var _loot_modifier = 0
var _chest_modifier = 0 # increase odds of getting a chest each time a chest isn't spawned


#==== Bootstrap ====#

func initialize():
	_money_generator.initialize(self)
	_potion_generator.initialize(self)
	_weapon_generator.initialize(self)



#==== Generate Level Loot ====# 

func generate_loot_in_room(room, room_number):
	randomize_chests_in_room(room, room_number)
	randomize_money_in_room(room, room_number)



#==== Chests ====#

func randomize_chests_in_room(room, room_number):
	randomize()
	var random_chest_index = floor(rand_range(6, 201))
	random_chest_index = 1 # Forces chest chance
	if random_chest_index - _loot_modifier <= room_number*3: # TODO improve
		spawn_random_chest(room)
		_chest_modifier = 0
	else:
		_chest_modifier += 4


func spawn_random_chest(room):
	var chest_instance = _CHEST_PREFAB.instance()
	var chest_item = spawn_random_chest_contents()
	chest_instance.initialize(chest_item)
	var random_position_index = floor(rand_range(0, room._CHEST_POSITIONS.size()))
	chest_instance.position = room._CHEST_POSITIONS[random_position_index]
	room.add_child(chest_instance)


func spawn_random_chest_contents():
	var item_type_id = floor(rand_range(1, 100))
	print("chest item id ", item_type_id)
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	
	var item
	if item_type_id < 20:
		item = _weapon_generator.spawn_low_tier_weapon(object_data_instance)
	if item_type_id < 40:
		item = _potion_generator.spawn_random_potion(object_data_instance)
	elif item_type_id < 70:
		item = _potion_generator.spawn_low_level_potion(object_data_instance)
	elif item_type_id < 80:
		item = _potion_generator.spawn_mid_level_potion(object_data_instance)
	elif item_type_id < 95:
		item = _money_generator.spawn_mid_value_money(object_data_instance)
	else:
		item = _potion_generator.spawn_random_potion(object_data_instance)
	return item


#==== Enemy Loot ====#

func spawn_low_level_enemy_loot(): # money, potions, low end gear
	var item_type_id = floor(rand_range(0, 100))
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	var item
	if item_type_id < 1: # weapon
		item = _weapon_generator.spawn_low_tier_weapon(object_data_instance)
	elif item_type_id < 5: # potion
		item = _potion_generator.spawn_low_level_potion(object_data_instance)
	else: # money
		item = _money_generator.spawn_low_value_money(object_data_instance)
		item._collision_shape.disabled = true
	return item


func spawn_mid_level_enemy_loot(): # good money, good potions, mid-good gear
	var item_type_id = floor(rand_range(1, 100))
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	var item
	if item_type_id < 5: # weapon
		item = _weapon_generator.spawn_low_tier_weapon(object_data_instance)
	if item_type_id < 15: # potion
		item = _money_generator.spawn_mid_value_money(object_data_instance)
		item._collision_shape.disabled = true
	else: # money
		item = _potion_generator.spawn_mid_level_potion(object_data_instance)
	return item


func spawn_high_level_enemy_loot(): # best money, legendary potions and key items
	pass


func spawn_boss_loot():
	pass




#=== Money Interface ===

func randomize_money_in_room(room, room_number):
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	_money_generator.randomize_money_in_room(room, room_number, object_data_instance)



#==== Weapon Interface ====#

func spawn_default_shortsword():
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	var weapon = _weapon_generator.spawn_default_shortsword(object_data_instance)
	return weapon

func spawn_low_tier_weapon():
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	var weapon = _weapon_generator.spawn_low_tier_weapon(object_data_instance)
	return weapon



#==== Utils ====#

func set_loot_modifier(new_loot_modifier):
	_loot_modifier = new_loot_modifier
	update_loot_modifier_in_components()

func add_loot_modifier(amount):
	_loot_modifier += amount
	update_loot_modifier_in_components()

func remove_loot_modifier(amount):
	_loot_modifier -= amount
	if _loot_modifier < 0:
		_loot_modifier = 0
	update_loot_modifier_in_components()

func update_loot_modifier_in_components():
	_money_generator._loot_modifier = _loot_modifier
	_potion_generator._loot_modifier = _loot_modifier
	_weapon_generator._loot_modifier = _loot_modifier


func set_chest_modifier(new_chest_modifier):
	_chest_modifier = new_chest_modifier

func add_chest_modifier(amount):
	_chest_modifier += amount

func remove_chest_modifier(amount):
	_chest_modifier -= amount
	if _chest_modifier < 0:
		_chest_modifier = 0
