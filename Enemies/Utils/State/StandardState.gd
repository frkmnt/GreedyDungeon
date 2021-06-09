extends Node

#==== References ====#
var _parent
var _physics_manager
var _turn_around_cast
var _animation_tree

#==== State ====#
export (int) var _current_hp = 3
var _current_action = "walk"

var _is_knockback = false
var _ready_to_attack = false



#==== Bootstrap ====#

func initialize(parent):
	_parent = parent
	_physics_manager = parent._physics_manager
	_animation_tree = parent._animation_tree
	set_state_neutral()




#==== State Handling ====#

func process_frame(delta):
	handle_state_logic()


func handle_state_logic():
	if not _is_knockback:
		_ready_to_attack = _physics_manager.is_player_in_attack_range() 
		if not _current_action == "attack":
			if _ready_to_attack:
				set_state_attack()
			
			elif should_turn_around():
				_physics_manager.change_direction()


func receive_attack(target_hitbox, attack):
	_animation_tree.stop()
	_current_hp -= attack._damage
	if check_if_dead():
		set_state_death()
	else:
		set_state_hurt()


#==== Logic ====#

func can_move():
	var can_move = false
	if not _is_knockback and not _ready_to_attack \
	and _current_action != "attack":
		can_move = true 
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

#==== Animation Management ====#

func set_state_neutral():
	_current_action = "neutral"
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
	_animation_tree.play("hurt")


func set_state_death():
	_current_action = "death"
	_is_knockback = true
	_physics_manager._is_stoping = true
	_animation_tree.play("death")


func check_if_dead():
	if _current_hp <= 0:
		return true
	return false


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
