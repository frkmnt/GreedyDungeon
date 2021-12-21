extends Node

#==== Class Comments ====#
# This holds all common weapon characteristics.

#==== Components ====#
var _attack_values_script


#==== Variables ====#
var _attack_dict = {} # {"attack_id": [[min_atk, max_atk], knockback, modifiers, anim_name]}
var _rune_slots = 0 # how many slots for general/specific mods
var _general_modifiers = []

var _crit_chance = 0 # in integer %

var _damage_modifier = 1
var _knockback_modifier = 1
var _crit_modifier = 1

var _current_attack_values
var _average_attack_values


#==== Bootstrap ====#

func initialize(attack_dict, crit_chance, attack_modifiers, rune_slots, modifiers):
	_attack_values_script = preload("res://Utils/Combat/AttackValues.gd")
	_attack_dict = attack_dict
	_crit_chance = crit_chance
	_damage_modifier = attack_modifiers[0]
	_knockback_modifier = attack_modifiers[1]
	_crit_modifier = attack_modifiers[2]
	_rune_slots = rune_slots
	_general_modifiers = modifiers
	_average_attack_values = get_average_attack_value()


#==== Logic ====#

func generate_new_attack(attack_id):
	var attack_values = _attack_dict.get(attack_id)
	var damage = floor(rand_range(attack_values[0][0], attack_values[0][1]))
	
	var crit_roll = rand_range(0, 100)
	if crit_roll <= _crit_chance:
		damage *= _crit_modifier
	
	_current_attack_values = _attack_values_script.new( \
		damage, attack_values[1], attack_values[2].duplicate())
#	print("atk ", _current_attack_values._damage)
	return attack_values[3] # attack id
	


func get_average_attack_value():
	var avg_atk = 0
	var avg_dmg
	var avg_crit_dmg
	var crit_percent
	for attack in _attack_dict.values():
		avg_dmg = (attack[0][0] + attack[0][1]) / 2
		avg_crit_dmg = avg_dmg * _crit_modifier
		crit_percent = _crit_chance / 100
		avg_atk += (avg_dmg * (1 - crit_percent)) + (avg_crit_dmg * crit_percent)
	return stepify(avg_atk / 8, 0.1) 
