extends Node2D

# Constansts

const _MONEY_PREFAB = preload("res://Objects/Money/Money.tscn")
const _CHEST_PREFAB = preload("res://Objects/Chest/Chest.tscn")


const _BAG_SPRITE = preload("res://Assets/Visual/Money/Bag.png")
const _GEM_SPRITE = preload("res://Assets/Visual/Money/Gem.png")
const _IDOL_SPRITE = preload("res://Assets/Visual/Money/Idol.png")
const _CRYSTAL_SPRITE = preload("res://Assets/Visual/Money/Crystal.png")
const _TREASURE_SPRITE = preload("res://Assets/Visual/Money/Treasure.png")


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


# Powerups


const _DOUBLE_JUMP_PREFAB = preload("res://Objects/Powerup/Double Jump/DoubleJump.tscn")
const _EXTRA_HEALTH_PREFAB = preload("res://Objects/Powerup/ExtraHealth/ExtraHealth.tscn")
const _EXTRA_SPEED_PREFAB = preload("res://Objects/Powerup/ExtraSpeed/ExtraSpeed.tscn")
const _BETTER_MONEY_PREFAB = preload("res://Objects/Powerup/BetterMoney/BetterMoney.tscn")

var _powerup_list = []




# Bootstrap

func initialize():
	_powerup_list.append(_DOUBLE_JUMP_PREFAB)
	_powerup_list.append(_EXTRA_HEALTH_PREFAB)
	_powerup_list.append(_EXTRA_SPEED_PREFAB)
	_powerup_list.append(_BETTER_MONEY_PREFAB)






# Logic 

func generate_loot_in_room(room, room_number):
	var money_odds
	
	if room_number < 30: # max profit caps at room nº30
		money_odds = _MONEY_ODDS[room_number]
	else:
		money_odds = _MONEY_ODDS[29] 
	
	randomize_chests_in_room(room, room_number)
	randomize_money_in_room(room, money_odds)



# Chests

func randomize_chests_in_room(room, room_number):
	randomize()
	var random_chest_index = floor(rand_range(6, 201))
	if random_chest_index <= room_number*2:
		var chest_instance = _CHEST_PREFAB.instance()
		chest_instance.initialize(get_random_powerup().instance())
		var random_position_index = floor(rand_range(0, room._CHEST_POSITIONS.size()))
		chest_instance.position = room._CHEST_POSITIONS[random_position_index]
		room.add_child(chest_instance)


func get_random_powerup():
	var random_powerup_index = floor(rand_range(0, _powerup_list.size()))
	return _powerup_list[random_powerup_index]






# Money

func randomize_money_in_room(room, money_odds):
	for money_prefab in room._money_container.get_children():
		randomize()
		var random_money_index = floor(rand_range(0, 201)) + _money_modifier
		if random_money_index > 200:
			random_money_index = 200
		if random_money_index > money_odds[0]:
			if random_money_index <= money_odds[1]:
				set_money_prefab_as_bag(money_prefab)
			elif random_money_index <= money_odds[2]:
				set_money_prefab_as_gem(money_prefab)
			elif random_money_index <= money_odds[3]:
				set_money_prefab_as_crystal(money_prefab)
			elif random_money_index <= money_odds[4]:
				set_money_prefab_as_idol(money_prefab)
			elif random_money_index <= money_odds[5]:
				set_money_prefab_as_treasure(money_prefab)
		



func set_money_prefab_as_bag(money_prefab):
	money_prefab.initialize(10, _BAG_SPRITE)


func set_money_prefab_as_gem(money_prefab):
	money_prefab.initialize(25, _GEM_SPRITE)


func set_money_prefab_as_crystal(money_prefab):
	money_prefab.initialize(50, _CRYSTAL_SPRITE)


func set_money_prefab_as_idol(money_prefab):
	money_prefab.initialize(100, _IDOL_SPRITE)


func set_money_prefab_as_treasure(money_prefab):
	money_prefab.initialize(250, _TREASURE_SPRITE)