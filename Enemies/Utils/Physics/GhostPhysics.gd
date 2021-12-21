extends Node2D

#==== Comments ====#
# Handles the standard behaviour's physics.
# This AI will turn around when facing a wall, or when any of
# its children (Cast2D) are not colliding with an obstacle.
# This works when checking if there is no more floor ahead.

#==== References ====#
var _parent
var _player

#==== Physics ====#
export (int) var _MAX_WALK_FORCE = 30
export (int) var _WALK_FORCE = 20
export (int) var _STOP_FORCE = 5
export (Vector2) var _DISTANCE_TO_ATTACK_PLAYER = Vector2(0, 0)
export (int) var _DISTANCE_TO_ATTACK_PLAYER_Y_OFFSET = 0 # in case the enemy is taller than the player

var _position
var _player_position
var _velocity = Vector2(0, 0)
var _facing_direction = -1 # left
var _is_stoping = false

var _despawn_pos = Vector2(-100, 500) # -100 to avoid despawning immediately


#==== Bootstrap ====#

func initialize(parent, player, position):
	_parent = parent
	_player = player
	_position = position




#==== Physics Handling ====#

func process_frame(delta, position, can_move): # called by the parent _physics_process()
	_position = position
	_player_position = _player.position
	handle_physics(delta, can_move)
	check_if_needs_to_be_despawned()


func handle_physics(delta, can_move):
	var force = Vector2(0, 0)
	
	if _is_stoping:
		stop_movement()
	elif can_move: # TODO improve
		var relative_player_pos = _player_position - _position
		_velocity = relative_player_pos * (_WALK_FORCE / relative_player_pos.length())
		if abs(_velocity.length()) > _MAX_WALK_FORCE:
			_velocity.x = _MAX_WALK_FORCE * _facing_direction
	
	_velocity += force * delta
	_velocity = _parent.move_and_slide(_velocity, Vector2(0, -1))


func change_direction():
	_facing_direction *= -1
	_velocity.x = _velocity.x * -1


func stop_movement():
	var v_sign_x = sign(_velocity.x)
	var v_len_x = abs(_velocity.x)
	v_len_x -= _STOP_FORCE
	if v_len_x < 0:
		v_len_x = 0
	_velocity.x = v_len_x * v_sign_x
	
	var v_sign_y = sign(_velocity.y)
	var v_len_y = abs(_velocity.y)
	v_len_y -= _STOP_FORCE
	if v_len_y < 0:
		v_len_y = 0
	_velocity.y = v_len_y * v_sign_y


func update_despawn_position(new_x_pos): # TODO should be a static reference to the value
	_despawn_pos.x = new_x_pos


func apply_knockback(body, attack, position):
	var is_enemy_on_right = position.x < body.get_parent().position.x
	if is_enemy_on_right:
		_velocity.x = attack._knockback.x * -1
		_velocity.y = attack._knockback.y
	else:
		_velocity.x = attack._knockback.x
		_velocity.y = attack._knockback.y


#==== Validations ====#

func get_distance_to_player():
	var p_position = _player.position
	return (p_position - _position).length()


func get_player_direction():
	var player_position = -1 # left
	if _player.position.x > _position.x:
		player_position = 1 # right
	return player_position


func handle_player_range():
	var _is_player_in_attack_range = [false, false] # is_in_attack_range, is_player_behind_in_range, is_player_in_move_range

	var p_position = _player.position
	var distance_to_player = p_position - _position
	
	if distance_to_player.y > 0:
		distance_to_player.y -= _DISTANCE_TO_ATTACK_PLAYER_Y_OFFSET
	if distance_to_player.y <= 0 \
	and abs(distance_to_player.y) <= _DISTANCE_TO_ATTACK_PLAYER.y: # player in valid range
		if abs(distance_to_player.x) <= _DISTANCE_TO_ATTACK_PLAYER.x:
			if sign(distance_to_player.x) == _facing_direction:
				_is_player_in_attack_range[0] = true
			else:
				_is_player_in_attack_range[1] = true
	return _is_player_in_attack_range



#	var player_direction_horizontal = sign(p_position.x - _position.x)
#	if player_direction_horizontal == 0:
#		player_direction_horizontal = _facing_direction






func is_player_on_top():
	var p_position = _player.position
	if abs(_position.x - p_position.x) < 9 \
		and p_position.y > 46 and p_position.y < 52:
			return true


func check_if_needs_to_be_despawned():
	if _position.x <= _despawn_pos.x or _position.y >= _despawn_pos.y:
		_parent.queue_free()


func check_if_casts_colliding(): # if any casts aren't colliding, the enemy should turn around
	var are_casts_colliding = true
	for child in get_children():
		if not child.is_colliding():
			are_casts_colliding = false
			break
	return are_casts_colliding

