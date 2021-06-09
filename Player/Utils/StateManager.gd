extends Node


#==== References ====#
var _player
var _animator
var _weapon
var _modifier_container

#==== Components ====#
var _i_frames_modifier


#==== State Controller ====#
var _current_action = "neutral" # idle, move, jump, attack, skill
var _is_touching_exit_portal = false

var _is_running = false
var _can_move = true
var _can_jump = true

var _is_stunned = false
var _is_invincible = false


#==== Physics Variables ====#
var _is_on_floor = true
var _is_on_ceiling = false
var _facing_direction = 1 # 0 is left, 1 is right

var _walk_speed = 400
var _max_walk_speed = 5000
var _stop_force = 300

var _gravity = 500
var _jump_force = -12500



#==== Meta Variables ====#
var _max_hp = 5
var _current_hp = _max_hp

var _i_frame_ticks = 4

var _max_jumps = 1
var _number_of_jumps = 0

var _current_money = 0



#==== Items Stats ====#
var _defense = 0


#==== Modifiers ====#
# dictionary of identifier : modifiers[]
# identifiers: passive, tick, delayed, receive_hit, condition,
var _modifier_type_list = []






#==== Bootstrap ====#

func initialize(parent_class):
	_player = parent_class
	_animator = _player._animator
	_weapon = _player._weapon
	_modifier_container = _player._modifier_container
	initialize_modifier_map()
	initialize_i_frames()
	initialize_meta_variables()


func test_modifiers():
	var modifier_manager = _player._overseer._modifier_manager
	
	var regenerating_health = modifier_manager.get_modifier_instance(4)
	regenerating_health.initialize_values(5)
	add_modifier(regenerating_health)




func initialize_modifier_map():
	for i in range(5):
		_modifier_type_list.append({})


func initialize_i_frames():
	_i_frames_modifier = load("res://Modifiers/OnHitIframes/OnHitIframes.tscn")


func initialize_meta_variables():
	_current_hp = _max_hp






#==== State Handling ====#

func handle_player_state():
	if _is_on_floor:
		_number_of_jumps = 0


func set_state_idle(): #also triggered when an animation finishes
	_current_action = "neutral"
	_is_stunned = false
	_can_move = true
	if _is_on_floor:
		if _is_running:
			_animator.play("run")
		else:
			_animator.play("idle")
	else:
		_animator.play("fall")

func set_state_move(): # REFACTOR CHANGE NAMES IN ANIMATION PLAYER
	if _current_action == "neutral":
		_is_running = true
		if _is_on_floor:
			_animator.play("run")
		else:
			_animator.play("fall")

func set_state_hurt():
	_current_action = "hurt"
	_is_stunned = true
	_can_move = false
	_player._hurtbox.set_collision_mask_bit(2, false)
	_animator.play("hurt")

func set_state_hurt_recovery():
	var i_frames = _i_frames_modifier.instance()
	i_frames.initialize_values(2) # 2 ticks
	add_modifier(i_frames)
	set_state_idle()


func check_if_dead():
	if _current_hp <= 0:
		# TODO handle death 
		print("dead")






#==== Action Management ====#

func can_use_action(action_input, action_frames):
	if action_frames == 1 and action_input != "idle":
		if _current_action == "neutral" or _current_action == "jump":
			return true
	return false


func handle_jump_action():
	if _number_of_jumps < _max_jumps:
		_current_action = "jump"
		_number_of_jumps += 1
		_player.apply_jump_force()
		_animator.play("jump")


func handle_attack_action(action_input):
	if _is_touching_exit_portal: 
		print("EXIT_GAME")
	else:
		_current_action = "attack"
		_can_move = false
		if _is_on_floor:
			
			match action_input: # TODO WEAPONS ARE TO CHANGE POSITION EACH ANIMATION KEYFRAME
				"neutral":
					_weapon.neutral_ground()
				"up":
					_weapon.up_ground()
				"left":
					if _facing_direction == 1:
						_player.change_direction()
						_facing_direction = -1
					_weapon.side_ground()
				"right":
					if _facing_direction == -1:
						_player.change_direction()
						_facing_direction = 1
					_weapon.side_ground()
				"down":
					_weapon.neutral_ground()
		
		else:
			match action_input:
				"neutral":
					_weapon.side_air()
				"up":
					_weapon.up_air()
				"left":
					if _facing_direction == 1:
						_player.change_direction()
						_facing_direction = -1
					_weapon.side_air()
				"right":
					if _facing_direction == -1:
						_player.change_direction()
						_facing_direction = 1
					_weapon.side_air()
				"down":
					_weapon.down_air()





#===== Event Management =====#

func add_money(amount):
	_current_money += amount
	return _current_money


func fill_hp():
	_current_hp = _max_hp

func add_hp(amount):
	_current_hp += amount
	if _current_hp > _max_hp:
		_current_hp = _max_hp

func increase_max_hp(value):
	_max_hp += value

func decrease_max_hp(value):
	_max_hp -= value
	if _current_hp > _max_hp:
		_current_hp = _max_hp

func lose_hp(amount):
	_current_hp -= amount



func receive_attack(attack, attacker_pos):
	
	attack = handle_receive_attack_modifiers(attack)
	
	_current_hp -= attack._damage
	
	var new_knockback = Vector2(0, attack._knockback_force.y)
	var is_enemy_on_right = _player.position.x < attacker_pos.x
	if is_enemy_on_right: 
		new_knockback.x = attack._knockback_force.x * -1
	else:
		new_knockback.x = attack._knockback_force.x
	_player.apply_knockback(new_knockback)
	
	for modifier in attack._modifiers:
		add_modifier(modifier)
	
	set_state_hurt()


func increase_movement_speed(value):
	_walk_speed += value








#==== Modifiers ====#

func add_modifier(new_modifier):
#	print("adding modifier ", new_modifier)
	var was_added = true
	var can_add_modifier = true
	
	# check if can add modifier
	var aux_modifier
	for modifier in _modifier_type_list[4]: # 4: receive_modifier
		aux_modifier = modifier
		can_add_modifier = aux_modifier.receive_modifier()
	if not can_add_modifier:
		return
	
	aux_modifier = get_modifier(new_modifier._id)
	if not aux_modifier == null: # existing modifier
		# print("existing modifier")
		was_added = false
		aux_modifier.on_stack(new_modifier)
	
	else: # new modifier
		# print("new modifier")
		var modifier_map
		for modifier_type_id in new_modifier._modifier_ids:
			modifier_map = _modifier_type_list[modifier_type_id]
			modifier_map[new_modifier._id] = new_modifier
		_modifier_container.add_child(new_modifier)
		new_modifier.initialize(_player) 
	return was_added





func remove_modifier(modifier):
	var modifier_map
	var cur_modifier
	for modifier_type_id in modifier._modifier_ids:
		# print("removing modifier: ", modifier_type_id)
		modifier_map = _modifier_type_list[modifier_type_id]
		modifier_map.erase(modifier._id)

func remove_modifiers(modifier_list):
	for modifier in modifier_list:
		remove_modifier(modifier)



func handle_receive_attack_modifiers(attack):
	var modifier_index = 0
	var modifiers_to_remove = []
	var modifier_map = _modifier_type_list[3]
	var sorted_modifiers = modifier_map.values()
	sorted_modifiers.sort_custom(self, "sort_modifier_array_by_priority")
	for modifier in sorted_modifiers:
		attack = modifier.on_receive_attack(attack)
		if modifier._needs_to_be_removed == true:
			modifiers_to_remove.append(modifier)
	remove_modifiers(modifiers_to_remove)
	return attack




func sort_modifier_array_by_priority(item_1, item_2):
	if item_1._priority < item_2._priority:
		return true
	return false



# returns a modifier corresponding to the id, or null if none exists
func get_modifier(modifier_id):
	for modifier in _modifier_container.get_children():
		if modifier_id == modifier._id \
		and not modifier._needs_to_be_removed:
			return modifier
	return null










