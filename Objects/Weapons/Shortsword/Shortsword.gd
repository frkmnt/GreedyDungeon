extends Sprite

#==== Comments ====#
# TODO add different behaviours depending on the attack.


#==== References ====#
var _player

#==== Components ====#
var _weapon_data
var _object_data 



#==== Bootstrap ====#

func initialize(weapon_data_instance, object_data):
	_weapon_data = weapon_data_instance
	initialize_object_data(object_data)


func initialize_object_data(object_data):
	var type = "weapon"
	var id = 20
	var name = "Shortsword"
	var description = "Favored by new adventurers and veterans alike, the shortsword is an overall fast and reliable weapon." 
	var value = 40 # TODO generate weapon value based on stats
	var stack_limit = 1
	_object_data = object_data
	_object_data.initialize(type, id, name, description, value, stack_limit, texture)


func init_with_player(player):
	_player = player





#==== Logic ====#

func get_current_attack_values():
	return _weapon_data._current_attack_values

func generate_new_attack(attack_id):
	handle_specific_attacks(attack_id)
	return _weapon_data.generate_new_attack(attack_id)
	


func handle_specific_attacks(attack_id):
	if attack_id == "down_air":
		_player._velocity.y = 5000




#==== Inventory Management ====#

func get_new_instance():
	var new_instance = get_script().new()
	new_instance._weapon_data = _weapon_data
	new_instance._object_data = _object_data
	return new_instance

func use_item(player):
	player._inventory.equip_weapon(self)
	player._state_manager._weapon = self
	init_with_player(player)







#==== Attack Received ====#

#func return_attack(): # REFACTOR add knockback as well
#	if _attack._id == "down_air":
#		var speed = _player_manager._velocity.y
#		if speed <= 12000:
#			_attack._damage = 10
#		elif speed <= 20000:
#			_attack._damage = 20
#		else:
#			_attack._damage = 30
#	return _attack
#
#



