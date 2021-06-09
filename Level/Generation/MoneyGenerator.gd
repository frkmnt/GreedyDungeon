extends Node2D

#==== Constants ====#
const _OBJECT_DATA_PREFAB = preload("res://Objects/Utils/ObjectData.gd")

const _MONEY_PREFAB = preload("res://Objects/Money/Money.tscn")
const _CHEST_PREFAB = preload("res://Objects/Chest/Chest.tscn")


const _COIN_SPRITE = preload("res://Assets/Visual/Money/Coin.png")
const _JEWEL_SPRITE = preload("res://Assets/Visual/Money/Jewel.png")
const _GEM_SPRITE = preload("res://Assets/Visual/Money/Gem.png")
const _IDOL_SPRITE = preload("res://Assets/Visual/Money/Idol.png")
const _CRYSTAL_SPRITE = preload("res://Assets/Visual/Money/Crystal.png")
const _TREASURE_SPRITE = preload("res://Assets/Visual/Money/Treasure.png")


const _small_health_potion_prefab = preload("res://Objects/Potions/SmallHealthPotion.tscn")
const _large_health_potion_prefab = preload("res://Objects/Potions/LargeHealthPotion.tscn")
const _shield_potion_prefab = preload("res://Objects/Potions/ShieldPotion.tscn")
const _extra_jump_potion_prefab = preload("res://Objects/Potions/ExtraJumpPotion.tscn")






# By order of odds: coin, bag, gem, idol, crystal, treasure
# Up to 50 floors
const _MONEY_ODDS = [ [200], [198, 200], [196, 200], [194, 200], [192, 200], #floors 1-5
					  [190, 198, 200], [188, 198, 200], [186, 198, 200], [184, 198, 200], [182, 196, 200], #floors 5-10
					  [180, 195, 199, 200], [178, 195, 199, 200], [176, 194, 199, 200], [174, 194, 199, 200], [172, 192, 198, 200], #floors 10-15
					  [170, 191, 197, 199, 200], [168, 191, 197, 199, 200], [166, 190, 197, 199, 200], [164, 189, 196, 199, 200], [162, 188, 195, 198, 200], #floors 15-20
					  [160, 186, 194, 197, 199, 200], [158, 186, 194, 197, 199, 200], [156, 184, 193, 197, 199, 200], [154, 183, 192, 197, 199, 200], [152, 183, 192, 197, 199, 200], #floors 20-25
					  [150, 182, 192, 197, 199, 200], [148, 182, 192, 197, 199, 200], [146, 181, 191, 197, 199, 200], [144, 180, 190, 196, 199, 200], [138, 178, 188, 194, 198, 200] #floors 25-30
					] 

var _money_modifier = 0
var _chest_modifier = 0





# Bootstrap

func initialize():
	pass




# Logic 

func generate_loot_in_room(room, room_number):
	var money_odds
	
	if room_number < 30: # max profit caps at room nº30
		money_odds = _MONEY_ODDS[room_number]
	else:
		money_odds = _MONEY_ODDS[29] 
	
	randomize_chests_in_room(room, room_number)
	randomize_money_in_room(room, money_odds)



#==== Chests ====#

func randomize_chests_in_room(room, room_number):
	randomize()
	var random_chest_index = floor(rand_range(6, 201))
	random_chest_index = 1 # Forces chest chance
	if random_chest_index - _chest_modifier <= room_number*3: # TODO improve
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
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	
	var item
	if item_type_id < 30:
		item = spawn_potion(object_data_instance)
		#item = spawn_high_value_money(object_data_instance) # TODO encapsulate within pickable object
	elif item_type_id < 70:
		item = spawn_potion(object_data_instance)
	elif item_type_id < 80:
		item = spawn_potion(object_data_instance)
	elif item_type_id < 90:
		item = spawn_potion(object_data_instance)
	else:
		item = spawn_potion(object_data_instance)
	
	return item



func spawn_high_value_money(object_data_instance):
	var money_instance = _MONEY_PREFAB.instance()  
	var random_money_index = floor(rand_range(0, 201)) + _money_modifier
	if random_money_index > 200:
		random_money_index = 200
	
	if random_money_index > 70:
		set_money_prefab_as_gem(money_instance, object_data_instance)
	elif random_money_index > 140:
		set_money_prefab_as_crystal(money_instance, object_data_instance)
	else:
		set_money_prefab_as_idol(money_instance, object_data_instance)
	return money_instance


func spawn_potion(object_data_instance):
	var potion_instance  # 10 to 40
	var random_potion_index = floor(rand_range(0, 34)) + _money_modifier
#	random_potion_index = 45
	if random_potion_index < 25:
		potion_instance = _small_health_potion_prefab.instance()
	elif random_potion_index < 35:
		potion_instance = _shield_potion_prefab.instance()
	elif random_potion_index < 45:
		potion_instance = _large_health_potion_prefab.instance()
	else:
		potion_instance = _extra_jump_potion_prefab.instance()
	potion_instance.initialize(object_data_instance)
	return potion_instance








#=== Money ===

func randomize_money_in_room(room, money_odds):
	randomize()
	for money_prefab in room._money_container.get_children():
		var object_data_instance = _OBJECT_DATA_PREFAB.new()
		var random_money_index = floor(rand_range(0, 201)) + _money_modifier
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



func set_money_prefab_as_coin(money_prefab, object_data):
	money_prefab.initialize(1, "Coin", "A gold coin.", _COIN_SPRITE, 1, 500, object_data)


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





#==== Enemy Loot ====#

func spawn_low_level_enemy_loot(): # money, potions, low end gear
	var item_type_id = floor(rand_range(1, 100))
	var object_data_instance = _OBJECT_DATA_PREFAB.new()
	var item
	if item_type_id < 10: # potion
		item = spawn_potion(object_data_instance)
	else: # money
		item = _MONEY_PREFAB.instance()
		item_type_id = floor(rand_range(1, 100))
		if item_type_id < 15:
			set_money_prefab_as_coin(item, object_data_instance)
		else:
			set_money_prefab_as_jewel(item, object_data_instance)
		item._collision_shape.disabled = true
	return item


func spawn_mid_level_enemy_loot(): # good money, good potions, mid-good gear
	pass


func spawn_high_level_enemy_loot(): # best money, legendary potions and key items
	pass


func spawn_boss_loot():
	pass
