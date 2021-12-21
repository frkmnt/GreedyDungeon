extends Node

#==== References ====#
var _parent
var _physics_manager
var _turn_around_cast
var _animation_tree
var _health_bar


#==== State ====#
export (int) var _max_hp = 1
export (int) var _total_recovery_anims = 0 # idle anims to play after attack
export (int) var _total_damage_until_stunlock = 0

var _current_action = "walk"
var _can_move = false
var _is_knockback = false
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
	_current_hp = _max_hp
	_remaining_recovery_anims = _total_recovery_anims
	set_state_move()




#==== State Handling ====#

func process_frame():
	_health_bar.set_health_bar_value(_current_hp)
	_health_bar.process_frame()


func handle_damage_state():
	if check_if_dead():
		_animation_tree.stop()
		set_state_death()
	elif _remaining_damage_until_stunlock <= 0:
		_animation_tree.stop()
		set_state_hurt()



#==== Validations ====#

func check_if_can_move():
	if not _is_knockback \
	and _current_action != "attack":
		_can_move = true 


func should_turn_around():
	var should_turn_around = false
	if _parent.is_on_floor():
		if _parent.is_on_wall():
			should_turn_around = true
		if not _physics_manager.check_if_casts_colliding():
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
		_is_knockback = true
		_physics_manager._is_stoping = false
		_animation_tree.play("idle", -1, 1.5)
	_remaining_recovery_anims -= 1


func set_state_move():
	_current_action = "move"
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
