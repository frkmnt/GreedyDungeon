extends KinematicBody2D

# Components
var _animation_tree 
var _sprite
var _hitbox_shape
var _visibility_enabler

var _player

# Physics
const _GRAVITY = 700
const _MAX_WALK_FORCE = 40
const _WALK_FORCE = 40
const _STOP_FORCE = 5

var _delta
var _velocity = Vector2()
var _facing_direction = -1 #left
var _is_stoping = false


# Meta
var _current_action = "walk"

var _current_hp = 3
var _is_knockback = false
var _ready_to_attack = false



#==== Bootstrap ====#

func _ready():
	set_process(false)
	set_physics_process(false)
	
	_sprite = $Sprite
	_animation_tree = $Sprite/AnimationPlayer
	_visibility_enabler = $VisibilityEnabler2D
	_player = get_tree().current_scene.get_node("Player")
	
	
	_hitbox_shape = $Hitbox.get_child(0)
	_hitbox_shape.disabled = true
	
	_facing_direction = -1
	set_scale(Vector2(-0.8, 0.8))
	set_state_neutral()




#==== State Handling ====#

func _process(delta):
	handle_state_logic()


func handle_state_logic():
	if not _is_knockback:
		is_player_in_attack_range() 
		if not _current_action == "attack":
			if _ready_to_attack:
				set_state_attack()
			
			elif is_on_wall():
				change_direction()


func set_state_neutral():
	_current_action = "walk"
	_is_knockback = false
	_is_stoping = false
	_animation_tree.play("walk", -1, 1.5)


func set_state_attack():
	_current_action = "attack"
	_is_stoping = true
	_animation_tree.play("attack")


func set_state_hurt():
	_current_action = "hurt"
	_is_knockback = true
	_is_stoping = true
	_animation_tree.play("hurt")


func set_state_death():
	_current_action = "death"
	_is_knockback = true
	_is_stoping = true
	_animation_tree.play("death")


func check_if_dead():
	if _current_hp <= 0:
		return true
	return false


func die():
	_player.add_money(10)
	queue_free()


#==== Physics Handling ====#

func _physics_process(delta):
		_delta = delta
		handle_physics()
		check_if_needs_to_be_despawned()


func handle_physics():
	var force = Vector2(0, _GRAVITY)
	
	if _is_stoping:
		stop_movement()
	
	if not _is_knockback and not _ready_to_attack:
		if _current_action != "attack":
			force.x = _WALK_FORCE * _facing_direction
			_velocity += force * _delta
			if abs(_velocity.x) > _MAX_WALK_FORCE:
				_velocity.x = _MAX_WALK_FORCE * _facing_direction
	
	_velocity += force * _delta
	_velocity = move_and_slide(_velocity, Vector2(0, -1))


func change_direction():
	if _facing_direction == 1:
		_facing_direction = -1
		set_scale(Vector2(-0.8, 0.8))
	else:
		_facing_direction = 1
		set_scale(Vector2(-0.8, -0.8))


func stop_movement():
	var vsign = sign(_velocity.x)
	var vlen = abs(_velocity.x)
	vlen -= _STOP_FORCE
	if vlen < 0:
		vlen = 0
	_velocity.x = vlen * vsign


func check_if_needs_to_be_despawned():
	if position.x <= -100 or position.y <= -100:
		print("Enemy ", name, " moved off limits, despawning...")
		queue_free()




#==== Collision Handling ====#

func received_hit(body):
	_animation_tree.stop()
	_current_hp -= 1
	if check_if_dead():
		set_state_death()
	else:
		set_state_hurt()
	
	apply_knockback(body)



func apply_knockback(body):
	var attack = body.get_parent().get_current_attack_values()
	var is_enemy_on_right = position.x < body.get_parent().position.x
	if is_enemy_on_right:
		_velocity.x = attack._knockback.x * -1
		_velocity.y = attack._knockback.y
	else:
		_velocity.x = attack._knockback.x
		_velocity.y = attack._knockback.y



func is_player_in_attack_range():
	var p_position = _player.position
	var relative_player_x_pos = position.x - p_position.x
	var player_direction = sign(relative_player_x_pos)
	relative_player_x_pos = abs(relative_player_x_pos)
	var relative_player_y_pos = abs(position.y - p_position.y)
	
	
	if relative_player_x_pos < 20 \
	and relative_player_y_pos < 20 \
	and player_direction != _facing_direction:
		_ready_to_attack = true
	else:
		_ready_to_attack = false


