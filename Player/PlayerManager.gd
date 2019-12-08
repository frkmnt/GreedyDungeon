extends KinematicBody2D


#==== COMPONENTS ====#
var _overseer
var _input_handler
var _animator
var _weapon


#==== META CONTROLLER ====#
var _max_hp = 10
var _current_hp = _max_hp

var _max_jumps = 2
var _number_of_jumps = 0
var _current_money = 0
var _is_touching_exit_portal = false

var _can_move = true
var _is_stunned = false

#==== STATE CONTROLLER ====#
var _current_action = "neutral" # neutral, jump, attack, skill

var _is_on_wall = false
var _is_on_floor = false
var _is_on_ceiling = false

var _is_stoping = false
var _is_running = false
var _facing_direction = 1 # right




#==== PHYSICS CONTROLLER ====#

const _GRAVITY = 700.0 # pixels/second
const _WALK_FORCE = 500
const _STOP_FORCE = 1500
const _JUMP_SPEED = 270
const _SLIDE_STOP_VELOCITY = 3.0 # pixels/second
const _SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel
const _PLAYER_SCALE = 0.8
var _walk_min_speed = 100
var _walk_max_speed = 176

var _velocity = Vector2()
var _delta = 0






#====== Bootstrap ======#

func initialize():
	_overseer = get_parent()
	initialize_input_handler()
	initialize_animations()
	initialize_weapons()
	idle()


func initialize_input_handler():
	var loaded_input_handler = preload("res://Player/Utils/InputHandler.gd")
	_input_handler = loaded_input_handler.new()


func initialize_animations():
	_animator = $Sprite.get_child(0)


func initialize_weapons():
	_weapon = $ActionHandlers/Weapon
	_weapon.inititialize()


func _process(delta):
	pass
	_input_handler.process_all_inputs()
	handle_player_logic()
	handle_world_positions()



func _physics_process(delta):
	_delta = delta
	handle_player_physics()




#===== Physics Handling =====#

func handle_player_physics():
	_is_stoping = true
	var force = get_movement_force()
	if _is_stoping:
		stop_movement()
	
	if _velocity.x == 0 and _current_action == "neutral":
		_is_running = false
		idle()
	_velocity += force * _delta
	_velocity = move_and_slide(_velocity, Vector2(0, -1))


func get_movement_force():
	var force = Vector2(0, _GRAVITY)
	if not _is_stunned and _can_move:
		var walk_left = _input_handler.directional_input_buffer.has("left")
		var walk_right = _input_handler.directional_input_buffer.has("right")
		
		if walk_left and walk_right:
			stop_movement()
		elif walk_left:
			force = walk_left(force)
		elif walk_right:
			force = walk_right(force)
	
	return force


func walk_left(force):
	if _current_action == "neutral" or not _is_on_floor:
		move()
		if abs(_velocity.x) < _walk_max_speed:
			force.x -= _WALK_FORCE
			_is_stoping = false
		else:
			_velocity.x = _walk_max_speed * _facing_direction
		
		if _current_action == "neutral":
			if _facing_direction == 1:
				_facing_direction = -1
				set_scale(Vector2(-0.8, 0.8))
	return force


func walk_right(force):
	if _current_action == "neutral" or not _is_on_floor:
		move()
		if abs(_velocity.x) < _walk_max_speed:
			force.x += _WALK_FORCE
			_is_stoping = false
		else:
			_velocity.x = _walk_max_speed * _facing_direction
		
		if _current_action == "neutral":
			if _facing_direction == -1:
				_facing_direction = 1
				set_scale(Vector2(-0.8, -0.8))
	return force


func stop_movement():
	var vsign = sign(_velocity.x)
	var vlen = abs(_velocity.x)
	vlen -= _STOP_FORCE * _delta
	if vlen < 0:
		vlen = 0
	_velocity.x = vlen * vsign


func handle_world_positions(): #Camera moves when player is on the screen edge
	if position.x > 200:
		var speed = 150 * _delta
		_overseer.update_all_node_positions(speed)


#===== Collision Management =====#

func hit_enemy(body):
	if body.has_method("set_knockback"):
		body.set_knockback(1000, position)


func _on_hurtbox_entered(area):
	if area.has_method("get_type"):
		match area.get_type():
			"money":
				add_money(area._value)
				area.queue_free()
			
			"exit_portal":
				_is_touching_exit_portal = true
			
			"damage":
				if not _is_stunned:
					receive_attack(area)
			
			"powerup":
				area.player_touched_powerup(self)


func on_hurtbox_exited(area):
	if area.has_method("get_type"):
		match area.get_type():
			"exit_portal":
				_is_touching_exit_portal = false





#===== Logic/State Handling =====#

func handle_player_logic():
	var action_input = _input_handler.action_input
	
	_is_on_floor = is_on_floor()
	_is_on_ceiling = is_on_ceiling()
	_is_on_wall = is_on_wall()
	
	if _is_on_floor:
		_number_of_jumps = 0
	
	if _current_action == "neutral" or _current_action == "jump":
		match action_input:
			"jump":
				jump()
			
			"attack":
				attack()
			
			"skill":
				skill()



func idle(): #also triggered when an animation finishes
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


func move():
	if _current_action == "neutral":
		_is_running = true
		if _is_on_floor:
			_animator.play("run")
		else:
			_animator.play("fall")


func jump():
	if _input_handler.input_jump == 1:
		if _number_of_jumps < _max_jumps:
			_current_action = "jump"
			_animator.play("jump")
			
			_number_of_jumps += 1
			_velocity.y = -_JUMP_SPEED


func attack():
	if _input_handler.input_attack == 1:
		if _is_touching_exit_portal:
			print("EXIT_GAME")
		else:
			_current_action = "attack"
			if _is_on_floor:
				_can_move = false
				match _input_handler.final_input:
					"attack":
						_weapon.neutral_ground()
					"up_attack":
						_weapon.up_ground()
					"down_attack":
						_weapon.up_ground()
					"left_attack":
						_weapon.side_ground()
					"right_attack":
						_weapon.side_ground()
			
			else:
				match _input_handler.final_input:
					"attack":
						_weapon.side_ground()
					"up_attack":
						_weapon.up_air()
					"down_attack":
						_weapon.down_air()
					"left_attack":
						_weapon.side_air()
					"right_attack":
						_weapon.side_air()


func skill():
	if _input_handler.input_skill == 1:
		_current_action = "skill"
		_animator.play("shortsword_up_air")


func hurt():
	_current_action = "hurt"
	_is_stunned = true
	
	_animator.play("hurt")




func check_if_landed():
	if _is_on_floor:
		idle()


func check_if_dead():
	if _current_hp <= 0:
		queue_free()





#===== Meta Handling =====#

func add_money(value):
	_current_money += value
	_overseer._ui_manager.update_money_value(_current_money)


func fill_hp():
	_current_hp = _max_hp
	update_hp()

func update_hp():
	_overseer._ui_manager.update_hp_value(_current_hp)


func receive_attack(attack):
	_current_hp -= attack._damage
	update_hp()
	check_if_dead()
	
	var is_enemy_on_right = position.x < attack.get_parent().global_position.x
	if is_enemy_on_right:
		_velocity.x = attack._knockback_force.x * -1
		_velocity.y = attack._knockback_force.y
	else:
		_velocity.x = attack._knockback_force.x
		_velocity.y = attack._knockback_force.y
	
	hurt()


func get_current_attack_values():
	return _weapon._attack


func increase_max_hp(value):
	_max_hp += value
	_current_hp += value
	update_hp()


func increase_movement_speed(value):
	_walk_min_speed += value
	_walk_max_speed += value 







