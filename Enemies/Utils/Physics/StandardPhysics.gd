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
export (int) var _GRAVITY = 700
export (int) var _MAX_WALK_FORCE = 30
export (int) var _WALK_FORCE = 20
export (int) var _STOP_FORCE = 5
export (Vector2) var _DISTANCE_TO_ATTACK_PLAYER = Vector2(0, 0)

var _position
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
	handle_physics(delta, can_move)
	check_if_needs_to_be_despawned()


func handle_physics(delta, can_move):
	var force = Vector2(0, _GRAVITY)
	
	if _is_stoping:
		stop_movement()
	
	if can_move: # TODO improve
		force.x = _WALK_FORCE * _facing_direction
		_velocity += force * delta
		if abs(_velocity.x) > _MAX_WALK_FORCE:
			_velocity.x = _MAX_WALK_FORCE * _facing_direction
	
	_velocity += force * delta
	_velocity = _parent.move_and_slide(_velocity, Vector2(0, -1))


func change_direction():
	_facing_direction *= -1
	_velocity.x = _velocity.x * _facing_direction
	var new_scale = _parent.get_scale()
	new_scale.x *= -1
	_parent.set_scale(new_scale)


func stop_movement():
	var vsign = sign(_velocity.x)
	var vlen = abs(_velocity.x)
	vlen -= _STOP_FORCE
	if vlen < 0:
		vlen = 0
	_velocity.x = vlen * vsign


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

func get_player_direction():
	var player_position = -1 # left
	if _player.position.x > _position.x:
		player_position = 1 # right
	return player_position
	

func is_player_in_attack_range():
	var p_position = _player.position
	var relative_player_y_pos = abs(_position.y - p_position.y)
	
	if relative_player_y_pos < _DISTANCE_TO_ATTACK_PLAYER.y:
		var relative_player_x_pos = p_position.x - _position.x
		var player_direction = sign(relative_player_x_pos)
		relative_player_x_pos = abs(relative_player_x_pos)
		if relative_player_x_pos < _DISTANCE_TO_ATTACK_PLAYER.x \
		and player_direction == _facing_direction:
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
