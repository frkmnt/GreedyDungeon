extends Node

#==== Class Comments ====#
# This class handles all money generation.


#==== References ====#
var _parent
var _rng

#==== Prefabs ====#
const _MONEY_PREFAB = preload("res://Objects/Money/Money.tscn")

const _COIN_SPRITE = preload("res://Assets/Visual/Money/Coin.png")
const _JEWEL_SPRITE = preload("res://Assets/Visual/Money/Jewel.png")
const _GEM_SPRITE = preload("res://Assets/Visual/Money/Gem.png")
const _IDOL_SPRITE = preload("res://Assets/Visual/Money/Idol.png")
const _CRYSTAL_SPRITE = preload("res://Assets/Visual/Money/Crystal.png")
const _TREASURE_SPRITE = preload("res://Assets/Visual/Money/Treasure.png")

#==== Constants ====#

# By order of odds: coin, bag, gem, idol, crystal, treasure
# Up to 50 floors
const _MONEY_ODDS = [ [200], [198, 200], [196, 200], [194, 200], [192, 200], #floors 1-5
					  [190, 198, 200], [188, 198, 200], [186, 198, 200], [184, 198, 200], [182, 196, 200], #floors 5-10
					  [180, 195, 199, 200], [178, 195, 199, 200], [176, 194, 199, 200], [174, 194, 199, 200], [172, 192, 198, 200], #floors 10-15
					  [170, 191, 197, 199, 200], [168, 191, 197, 199, 200], [166, 190, 197, 199, 200], [164, 189, 196, 199, 200], [162, 188, 195, 198, 200], #floors 15-20
					  [160, 186, 194, 197, 199, 200], [158, 186, 194, 197, 199, 200], [156, 184, 193, 197, 199, 200], [154, 183, 192, 197, 199, 200], [152, 183, 192, 197, 199, 200], #floors 20-25
					  [150, 182, 192, 197, 199, 200], [148, 182, 192, 197, 199, 200], [146, 181, 191, 197, 199, 200], [144, 180, 190, 196, 199, 200], [138, 178, 188, 194, 198, 200] #floors 25-30
					] 

#==== Variables ====#
var _loot_modifier = 0





#==== Bootstrap ====#

func initialize(parent):
	_parent = parent
	_rng = RandomNumberGenerator.new()
	_rng.randomize()





#==== Level Money Spawning ====#

func randomize_money_in_room(room, room_number, object_data_instance):
	randomize()
	var money_odds = get_money_odds(room_number)
	
	for money_prefab in room._money_container.get_children():
		var random_money_index = floor(rand_range(0, 201)) + _loot_modifier
		if random_money_index > 200:
			random_money_index = 200
		if random_money_index > money_odds[0]:
			if random_money_index <= money_odds[1]:
				set_money_prefab_as_jewel(money_prefab, object_data_instance)
			elif random_money_index <= money_odds[2]:
				set_money_prefab_as_gem(money_prefab, object_data_instance)
			elif random_money_index <= money_odds[3]:
				set_money_prefab_as_crystal(money_prefab, object_data_instance)
			elif random_money_index <= money_odds[4]:
				set_money_prefab_as_idol(money_prefab, object_data_instance)
			elif random_money_index <= money_odds[5]:
				set_money_prefab_as_treasure(money_prefab, object_data_instance)
		else: # coin
			set_money_prefab_as_coin(money_prefab, object_data_instance)



#==== General Money Spawning ====#

func spawn_low_value_money(object_data_instance):
	var money_instance = _MONEY_PREFAB.instance()  
	var random_money_index = floor(rand_range(0, 100)) + _loot_modifier
	if random_money_index < 50:
		set_money_prefab_as_coin(money_instance, object_data_instance)
	else:
		set_money_prefab_as_jewel(money_instance, object_data_instance)
	return money_instance

func spawn_mid_value_money(object_data_instance):
	var money_instance = _MONEY_PREFAB.instance()  
	var random_money_index = floor(rand_range(0, 201)) + _loot_modifier
	if random_money_index < 50:
		set_money_prefab_as_gem(money_instance, object_data_instance)
	else:
		set_money_prefab_as_crystal(money_instance, object_data_instance)
	return money_instance

func spawn_high_value_money(object_data_instance):
	var money_instance = _MONEY_PREFAB.instance()  
	var random_money_index = floor(rand_range(0, 100)) + _loot_modifier
	if random_money_index < 50:
		set_money_prefab_as_idol(money_instance, object_data_instance)
	else:
		set_money_prefab_as_treasure(money_instance, object_data_instance)
	return money_instance





#==== Money Prefab Initialization ====#

func set_money_prefab_as_coin(money_prefab, object_data):
	money_prefab.initialize(1, "Gold Coin", "A shiny, well polished coin made of solid gold. The official currency of the realm.", _COIN_SPRITE, 1, 500, object_data)


func set_money_prefab_as_jewel(money_prefab, object_data):
	money_prefab.initialize(2, "Jewel", "A valuable jewel.", _JEWEL_SPRITE, 10, 150, object_data)


func set_money_prefab_as_gem(money_prefab, object_data):
	money_prefab.initialize(3, "Gem", "A semi precious stone.", _GEM_SPRITE, 25, 100, object_data)


func set_money_prefab_as_crystal(money_prefab, object_data):
	money_prefab.initialize(4, "Crystal", "A rare crystal procured for its curious effects.", _CRYSTAL_SPRITE, 50, 75, object_data)


func set_money_prefab_as_idol(money_prefab, object_data):
	money_prefab.initialize(5, "Idol", "An idol of immense magical properties.", _IDOL_SPRITE, 100, 50, object_data)


func set_money_prefab_as_treasure(money_prefab, object_data):
	money_prefab.initialize(6, "Treasure", "A chest filled with unbelievable treasures.", _TREASURE_SPRITE, 250, 30, object_data)


#==== Utils ====#

func get_money_odds(room_number):
	var money_odds
	if room_number < 30: # max profit caps at room nº30
		money_odds = _MONEY_ODDS[room_number]
	else:
		money_odds = _MONEY_ODDS[29] 
	return money_odds
