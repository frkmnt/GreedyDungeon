extends Node2D

#==== References ====#
var _parent
var _physics_manager
var _turn_around_cast
var _animation_tree
var _health_bar

#==== Components ====#
var _player_range_raycast

#==== State ====#
export (int) var _max_hp = 1
export (bool) var _should_turn_around_to_attack = false
export (int) var _total_recovery_anims = 0 # idle anims to play after attack
export (int) var _total_damage_until_stunlock = 0

var _current_action = "walk"
var _can_move = false
var _is_knockback = false
var _ready_to_attack = false # is_in_attack_range, is_player_behind_in_range
var _is_player_in_attack_range = [false, false]
var _current_hp = 1
var _remaining_recovery_anims = 0
var _remaining_damage_until_stunlock = 0


#==== Bootstrap ====#

func initialize(parent):
	_parent = parent
	_physics_manager = parent._physics_manager
	_animation_tree = parent._animation_tree
	_health_bar = parent._health_bar
	_health_bar.initialize(_max_hp)
	_player_range_raycast = $PlayerRangeRaycast
	_current_hp = _max_hp
	_remaining_recovery_anims = _total_recovery_anims
	_remaining_damage_until_stunlock = _total_damage_until_stunlock
	set_state_move()




#==== State Handling ====#

func process_frame():
	_health_bar.set_health_bar_value(_current_hp)


func handle_state_logic():
	_can_move = false
	_physics_manager._is_stoping = true
	_is_player_in_attack_range = _physics_manager.handle_player_range() 
	if not _is_knockback:
		if not _current_action == "attack":
			if _is_player_in_attack_range[0]:
				set_state_attack()
				_ready_to_attack = true
			elif check_if_can_move():
				_can_move = true
				_physics_manager._is_stoping = false
			elif should_turn_around():
				_physics_manager.change_direction()
				_parent.change_direction()
	print("can move ", _can_move)


func receive_attack(attack): # TODO add resistances
	_current_hp -= attack._damage
	_remaining_damage_until_stunlock  -= attack._damage
	if _should_turn_around_to_attack and _is_player_in_attack_range[1] \
	and not _current_action == "hurt":
		_physics_manager.change_direction()
		_parent.change_direction()





#==== Validations ====#

func check_if_player_in_move_range():
	var is_player_in_move_range = false
	if _player_range_raycast.is_colliding() \
	and _player_range_raycast.get_collider().name == "Player":
		 is_player_in_move_range = true
	return is_player_in_move_range

func check_if_can_move():
	var can_move = false
	if not _is_knockback and not _ready_to_attack \
	and _current_action != "attack" and check_if_player_in_move_range():
		can_move = true 
		print("can move!!")
	return can_move


func should_turn_around():
	var should_turn_around = false
	if _parent.is_on_floor():
		if _parent.is_on_wall():
			should_turn_around = true
		var are_casts_colliding = _physics_manager.check_if_casts_colliding()
		if not are_casts_colliding:
			should_turn_around = true
	return should_turn_around

func check_if_dead():
	if _current_hp <= 0:
		return true
	return false


#==== Animation Management ====#

func set_state_idle(): # recovery after attack
	if _remaining_recovery_anims <= 0:
		_remaining_recovery_anims = _total_recovery_anims
		set_state_move()
	else:
		_current_action = "idle"
		_ready_to_attack = false
		_is_knockback = true
		_physics_manager._is_stoping = false
		_animation_tree.play("idle", -1, 1.5)
	_remaining_recovery_anims -= 1


func set_state_move():
	_current_action = "move"
	_ready_to_attack = false
	_is_knockback = false
	_physics_manager._is_stoping = false
	_animation_tree.play("move", -1, 1.5)


func set_state_attack():
	_current_action = "attack"
	_physics_manager._is_stoping = true
	_animation_tree.play("attack")


func set_state_hurt():
	_current_action = "hurt"
	_is_knockback = true
	_physics_manager._is_stoping = true
	_remaining_damage_until_stunlock = _total_damage_until_stunlock
	_animation_tree.play("hurt")


func set_state_death():
	_current_action = "death"
	_is_knockback = true
	_physics_manager._is_stoping = true
	_animation_tree.play("death")


func handle_damage_state():
	_health_bar.visible = true
	if check_if_dead():
		_animation_tree.stop()
		set_state_death()
	else:
		if _remaining_damage_until_stunlock <= 0:
			_animation_tree.stop()
			set_state_hurt()



#==== Event Management ====#

func die():
	_parent.queue_free()


func spawn_pickable_object():
	var pickable_object = _parent._pickable_object
	_parent.remove_child(pickable_object)
	
	var level_manager = get_tree().current_scene.get_node("LevelManager")
	var cur_room = level_manager.match_room_with_x_position(_parent.position.x)
	var new_pos = _parent.get_global_position()
	new_pos.x -= cur_room.position.x # convert from global to local pos
	pickable_object.set_position(new_pos)
	cur_room.add_child(pickable_object)
	
	var item_launch_direction = _physics_manager.get_player_direction() * -1
	pickable_object.spawn_item(item_launch_direction)
