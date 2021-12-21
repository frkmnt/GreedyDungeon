extends Node

#==== Class Comments ====#
# This class handles all potion generation.


#==== References ====#
var _parent
var _rng

#==== Prefabs ====#
const _small_health_potion_prefab = preload("res://Objects/Potions/SmallHealthPotion.tscn")
const _large_health_potion_prefab = preload("res://Objects/Potions/LargeHealthPotion.tscn")
const _shield_potion_prefab = preload("res://Objects/Potions/ShieldPotion.tscn")
const _extra_jump_potion_prefab = preload("res://Objects/Potions/ExtraJumpPotion.tscn")
const _regenerating_health_potion_prefab = preload("res://Objects/Potions/RegeneratingHealthPotion.tscn")

#==== Variables ====#
var _loot_modifier = 0




#==== Bootstrap ====#

func initialize(parent):
	_parent = parent
	_rng = RandomNumberGenerator.new()
	_rng.randomize()





#==== General Potion Spawning ====#

func spawn_random_potion(object_data_instance):
	var potion_instance  # 10 to 40
	var random_potion_index = floor(rand_range(0, 85)) + _loot_modifier
	random_potion_index = 64 # force specific potion
	if random_potion_index < 25:
		potion_instance = _small_health_potion_prefab.instance()
	elif random_potion_index < 35:
		potion_instance = _shield_potion_prefab.instance()
	elif random_potion_index < 45:
		potion_instance = _large_health_potion_prefab.instance()
	elif random_potion_index < 65:
		potion_instance = _regenerating_health_potion_prefab.instance()
	else:
		potion_instance = _extra_jump_potion_prefab.instance()
	potion_instance.initialize(object_data_instance)
	return potion_instance




func spawn_low_level_potion(object_data_instance):
	var potion_instance
	var random_money_index = floor(rand_range(0, 100)) + _loot_modifier
	if random_money_index < 50:
		potion_instance = _small_health_potion_prefab.instance()
	else:
		potion_instance = _extra_jump_potion_prefab.instance()
	potion_instance.initialize(object_data_instance)
	return potion_instance

func spawn_mid_level_potion(object_data_instance):
	var potion_instance
	var random_money_index = floor(rand_range(0, 100)) + _loot_modifier
	if random_money_index < 40:
		potion_instance = _large_health_potion_prefab.instance()
	elif random_money_index < 80:
		potion_instance = _shield_potion_prefab.instance()
	else:
		potion_instance = _regenerating_health_potion_prefab.instance()
	potion_instance.initialize(object_data_instance)
	return potion_instance

func spawn_high_level_potion(object_data_instance):
	pass






