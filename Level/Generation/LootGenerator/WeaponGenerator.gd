extends Node

#==== Class Comments ====#
# This class handles all weapon and weapon related buff generation.


#==== References ====#
var _parent
var _rng

#==== Prefabs ====#
const _WEAPON_DATA_PREFAB = preload("res://Objects/Weapons/WeaponData.gd")
const _shortsword_prefab = preload("res://Objects/Weapons/Shortsword/Shortsword.tscn")

#==== Variables ====#
var _loot_modifier = 0




#==== Bootstrap ====#

func initialize(parent):
	_parent = parent
	_rng = RandomNumberGenerator.new()
	_rng.randomize()


#==== General Weapon Spawning ====#

func spawn_low_tier_weapon(object_data_instance):
	var weapon_data_instance = _WEAPON_DATA_PREFAB.new()
	var weapon = spawn_low_tier_shortsword(object_data_instance, weapon_data_instance)
	return weapon





#==== Shortsword Spawning ====#

func spawn_default_shortsword(object_data_instance):
	var weapon_data_instance = _WEAPON_DATA_PREFAB.new()
	var attack_dict = generate_shortsword_attack_values(1, 1)
	return spawn_shortsword(object_data_instance, weapon_data_instance, attack_dict, \
		5, [1, 1, 1.5], 0, [])


func spawn_low_tier_shortsword(object_data_instance, weapon_data_instance):
	var crit_chance_modifier = floor(_rng.randfn(10, 5)) # crit chance
	var crit_chance
	if crit_chance_modifier > 12:
		crit_chance = rand_range(17, 25)
	else:
		crit_chance = rand_range(5, 8)
	
	var _damage_modifier = _rng.randfn(1, 0.5) # damage
	if _damage_modifier <= 1:
		_damage_modifier = 1
	var knockback_modifier = floor(_rng.randfn(1, 0.2)) # knockback
	if knockback_modifier <= 1:
		knockback_modifier = 1
	var crit_damage_modifier = floor(_rng.randfn(2, 0.6)) # crit damage
	if crit_damage_modifier <= 1.5:
		crit_damage_modifier = 1.5
	var attack_modifiers = [_damage_modifier, knockback_modifier, crit_damage_modifier]
	
	var modifiers = [] # for status effects
	var rune_slots = floor(rand_range(0, 100)) # modifier slots
	if rune_slots < 3: # generate 1 rune, 10% chance
		rune_slots = 1
		var should_have_modifier = floor(rand_range(1, 100))
		if should_have_modifier < 5: # add modifier to weapon
			print("adding modifier to weapon")
	
	var attack_dict = generate_shortsword_attack_values(_damage_modifier, knockback_modifier)
	return spawn_shortsword(object_data_instance, weapon_data_instance, attack_dict, 	
		crit_chance, attack_modifiers, rune_slots, modifiers)


func spawn_shortsword(object_data_instance, weapon_data_instance, attack_dict, crit_chance, attack_modifiers, rune_slots, modifiers):
	weapon_data_instance.initialize(attack_dict, crit_chance, attack_modifiers, rune_slots, modifiers)
	var shortsword_instance = _shortsword_prefab.instance()
	shortsword_instance.initialize(weapon_data_instance, object_data_instance)
	return shortsword_instance


func generate_shortsword_attack_values(attack_modifier, knockback_modifier):
	var up_ground_attack = create_new_attack_with_modifier(10, 12, attack_modifier)
	var up_ground_knockback = create_new_knockback_with_modifier(25, -225, knockback_modifier)
	var down_ground_attack = create_new_attack_with_modifier(12, 16, attack_modifier)
	var down_ground_knockback = create_new_knockback_with_modifier(100, 50, knockback_modifier)
	var side_ground_attack = create_new_attack_with_modifier(9, 11, attack_modifier)
	var side_ground_knockback = create_new_knockback_with_modifier(50, 0, knockback_modifier)
	
	var up_air_attack = create_new_attack_with_modifier(7, 10, attack_modifier)
	var up_air_knockback = create_new_knockback_with_modifier(5, -200, knockback_modifier)
	var down_air_attack = create_new_attack_with_modifier(7, 9, attack_modifier)
	var down_air_knockback = create_new_knockback_with_modifier(30, 75, knockback_modifier)
	var side_air_attack = create_new_attack_with_modifier(9, 10, attack_modifier)
	var side_air_knockback = create_new_knockback_with_modifier(45, 0, knockback_modifier)
	
	return {
		"up_ground": [ up_ground_attack, up_ground_knockback, [], "shortsword_up_ground" ],
		"down_ground": [ down_ground_attack, down_ground_knockback, [], "shortsword_down_ground" ],
		"side_ground": [ side_ground_attack, side_ground_knockback, [], "shortsword_side_ground" ],
		"up_air": [ up_ground_attack, up_ground_knockback, [], "shortsword_up_air" ],
		"down_air": [ down_ground_attack, down_ground_knockback, [], "shortsword_down_air" ],
		"side_air": [ side_ground_attack, side_ground_knockback, [], "shortsword_side_air" ]
	}






#==== Weapon Spawning Utils ====#

func create_new_attack_with_modifier(min_value, max_value, attack_modifier):
	var min_damage = floor(min_value * attack_modifier)
	var max_damage = floor(max_value * attack_modifier)
	return [min_damage, max_damage]

func create_new_knockback_with_modifier(x_value, y_value, knockback_modifier):
	var x_knockback = floor(x_value * knockback_modifier)
	var y_knockback = floor(y_value * knockback_modifier)
	return Vector2(x_knockback, y_knockback)



