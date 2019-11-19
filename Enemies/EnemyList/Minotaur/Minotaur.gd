extends KinematicBody2D

# Components
var _animation_tree 
var _sprite
var _visibility_enabler
var _minotaur_attack

var _player
var _level_manager

# Physics
var _gravity = 700
var _max_walk_force = 75
var _previous_max_walk_force = 75
var _walk_force = 75
var _previous_walk_force = 75
var _stop_force = 75
var _previous_stop_force = 75



var _delta
var _velocity = Vector2()
var _facing_direction
var _is_stoping = false
var _can_turn = true

var _relative_player_position = 0 # determines where to turn
var _p_position = 0

# Meta
var _current_action = "walk"
var _current_stage = 1 # stage 1 has attack3,, 2 has attack2, and 3 attack1 
var _max_spins = 3
var _current_spins = 0
var _current_idles = 0
var _can_move = false

var _recovery_quantity = 3
var _current_recovery = 0

var _current_hp = 21
var _is_immune = false # boss is immune until its attack





#==== Bootstrap ====#

func _ready():
	set_process(false)
	set_physics_process(false)
	_facing_direction = 1
	
	_sprite = $Sprite
	_animation_tree = $Sprite/AnimationPlayer
	_visibility_enabler = $VisibilityEnabler2D
	_minotaur_attack = $Hitbox
	
	
	_player = get_tree().current_scene.get_node("Player")
	_level_manager = get_tree().current_scene.get_node("LevelManager")
	
	set_state_neutral()







#==== Stage Handling ====#

func next_stage():
	if _current_stage == 1:
		_current_stage = 2
		_previous_max_walk_force = _max_walk_force 
		_max_walk_force = 100
		_previous_walk_force = _walk_force 
		_walk_force = 90
		_previous_stop_force = _stop_force
		_stop_force = 100
	else:
		_current_stage = 3
		_previous_max_walk_force = _max_walk_force 
		_max_walk_force = 125
		_previous_walk_force = _walk_force 
		_walk_force = 100
		_previous_stop_force = _stop_force
		_stop_force = 125






#==== State Handling ====#

func _process(delta):
	_p_position = _player.position
	var player_position = position.x - _p_position.x
	_relative_player_position = sign(player_position)
	handle_state_logic()
	var hitbox = $Hitbox/HitboxShape.disabled


func handle_state_logic():
	if _current_action == "walk":
		apply_current_stage_attack()


func set_state_neutral():
	_current_action = "walk"
	
	_max_walk_force = _previous_max_walk_force
	_walk_force = _previous_walk_force
	_stop_force = _previous_stop_force
	
	_current_recovery = 0
	_is_stoping = false
	_can_turn = true
	_is_immune = false
	
	_animation_tree.play("walk")


func set_state_idle():
	_current_action = "idle"
	
	_max_walk_force = _previous_max_walk_force
	_walk_force = _previous_walk_force
	_stop_force = _previous_stop_force
	
	_is_stoping = true
	_can_turn = true
	_is_immune = true
	
	_animation_tree.play("idle")
	

func handle_state_idle():
	_current_idles += 1
	if _current_idles == 3:
		_current_idles = 0
		set_state_neutral()
	else:
		_animation_tree.play("idle")
	




func apply_current_stage_attack():
	if is_player_in_attack_range():
		_current_action = "attack"
		_can_turn = false
		_is_immune = true
		_current_recovery = 0
		
		if _current_stage == 1: # Stage 1
			_is_stoping = true
			_minotaur_attack._damage = 2
			_minotaur_attack._knockback_force = Vector2(400, -300)
			_recovery_quantity = 4
			_animation_tree.play("attack1") 
		
		elif _current_stage == 2: # Stage 2
			var random_attack_index = floor(rand_range(0, 100))
			if random_attack_index <= 50:
				_is_stoping = true
				_minotaur_attack._damage = 1
				_minotaur_attack._knockback_force = Vector2(400, -300)
				_recovery_quantity = 4
				_animation_tree.play("attack1")
			else:
				_is_stoping = true
				_minotaur_attack._damage = 2
				_minotaur_attack._knockback_force = Vector2(300, 0)
				_recovery_quantity = 3
				_animation_tree.play("attack3")
			
		else: # Stage 3
			var random_attack_index = floor(rand_range(0, 100))
			if random_attack_index <= 30:
				_is_stoping = true
				_minotaur_attack._damage = 2
				_minotaur_attack._knockback_force = Vector2(300, 0)
				_recovery_quantity = 1
				_animation_tree.play("attack3")
			elif random_attack_index <= 70:
				_minotaur_attack._damage = 1
				_minotaur_attack._knockback_force = Vector2(600, -200)
				_previous_max_walk_force = _max_walk_force 
				_max_walk_force = 150
				_previous_walk_force = _walk_force 
				_walk_force = 125
				_previous_stop_force = _stop_force
				_stop_force = 130

				_max_spins = 10
				_recovery_quantity = 6
				_animation_tree.play("attack2")
			else:
				_is_stoping = true
				_minotaur_attack._damage = 1
				_minotaur_attack._knockback_force = Vector2(500, -400)
				_recovery_quantity = 3
				_animation_tree.play("attack1")


func spin_to_win():
	_current_spins += 1
	if _current_spins >= _max_spins:
		_current_spins = 0
		_current_action = "recover"
		_animation_tree.play("spin_to_win_recover")
	else:
		_animation_tree.play("spin_to_win")


func finish_ultimate_setup():
	_animation_tree.play("attack1")



func set_state_recover():
	_current_action = "recover"
	
	_max_walk_force = _previous_max_walk_force
	_walk_force = _previous_walk_force
	_stop_force = _previous_stop_force
	
	_is_stoping = true
	_can_turn = true
	_is_immune = false
	_current_recovery += 1
	
	if _current_recovery == _recovery_quantity:
		set_state_neutral()
	else:
		_animation_tree.play("recover")






func set_state_hurt():
	_current_action = "hurt"
	
	_max_walk_force = _previous_max_walk_force
	_walk_force = _previous_walk_force
	_stop_force = _previous_stop_force
	
	_is_stoping = true
	_can_turn = false
	_is_immune = true
	_animation_tree.play("hurt")


func set_state_death():
	_current_action = "death"
	_is_stoping = true
	_is_immune = true
	_animation_tree.play("death")





func check_if_dead():
	if _current_hp <= 0:
		return true
	return false


func die():
	_player.fill_hp()
	_player.add_money(500)
	_level_manager._is_currently_boss_battle = false
	queue_free()












#==== Physics Handling ====#

func _physics_process(delta):
		_delta = delta
		handle_physics()
		check_if_needs_to_be_despawned()


func handle_physics():
	var force = Vector2(0, _gravity)
	
	if _can_turn:
		handle_direction()
	
	if _is_stoping:
		stop_movement()
	else:
		force.x = _walk_force * -_relative_player_position
		_velocity += force * _delta
		if abs(_velocity.x) > _max_walk_force:
			_velocity.x = _max_walk_force * -_relative_player_position
	
	_velocity += force * _delta
	_velocity = move_and_slide(_velocity, Vector2(0, -1))


func handle_direction():
	if (_facing_direction == 1 and _player.position.x <= position.x) \
	or (_facing_direction == -1 and _player.position.x > position.x):
		change_direction()


func change_direction():
	if _facing_direction == 1:
		_facing_direction = -1
		set_scale(Vector2(-1, 1))
	else:
		_facing_direction = 1
		set_scale(Vector2(-1, -1))


func stop_movement():
	var vsign = sign(_velocity.x)
	var vlen = abs(_velocity.x)
	vlen -= _stop_force
	if vlen < 0:
		vlen = 0
	_velocity.x = vlen * vsign


func check_if_needs_to_be_despawned():
	if position.x <= -100 or position.y <= -100:
		queue_free()




#==== Collision Handling ====#

func received_hit(body):
	if not _is_immune:
		_current_hp -= 1
		print("cur hp ", _current_hp)
		
		if check_if_dead():
			set_state_death()
		elif _current_hp % 7 == 0:
			set_state_hurt()
			next_stage()



func is_player_in_attack_range():
	if abs(position.x - _p_position.x) < 35 \
	and _p_position.y > 110:
		return true


