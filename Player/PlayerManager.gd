extends KinematicBody2D

#==== References ====#
var _overseer
var _level_manager 


#==== Components ====#
var _effect_container
var _weapon
var _modifier_container
var _animator
var _hitbox
var _hurtbox

var _input_handler
var _inventory
var _state_manager


#==== Physics Controller ====#
var _velocity = Vector2()
var _delta = 0






#====== Bootstrap ======#

func initialize():
	_overseer = get_parent()
	
	initialize_effect_container()
	initialize_animations()
	initialize_weapons()
	initialize_hitboxes()
	
	initialize_input_handler()
	initialize_inventory()
	initialize_map_manager()
	
	initialize_state_manager()
	_state_manager.set_state_idle()


func _ready():
	#_state_manager.test_modifiers() #TODO REFACTOR test func don't forget to remove
	_state_manager.initialize_meta_variables()


func initialize_effect_container():
	_effect_container = $EffectContainer

func initialize_input_handler():
	var loaded_input_handler = load("res://Player/Utils/InputManager.gd") #TODO REFACTOR USED TO BE PRELOAD, COULDA FUCKA THINGS UP
	_input_handler = loaded_input_handler.new()

func initialize_animations():
	_animator = $Sprite.get_child(0)

func initialize_weapons():
	_weapon = $Weapon
	_weapon.initialize()

func initialize_hitboxes():
	_hitbox = $Hitbox
	_hurtbox = $Hurtbox

func initialize_inventory():
	_inventory = load("res://Player/Utils/InventoryManager.gd").new()
	_inventory.initialize(_overseer._ui_manager._inventory_panel)

func initialize_map_manager():
	_level_manager = _overseer._level_manager

func initialize_state_manager():
	_modifier_container = $ModifierContainer
	_state_manager = load("res://Player/Utils/StateManager.gd").new()
	_state_manager.initialize(self)





#===== Tick =====#

func _process(delta):
	_input_handler.process_all_inputs()
	_state_manager.handle_player_state()
	handle_player_action()
	handle_player_movement_action()


func _physics_process(delta):
	_delta = delta
	handle_player_physics()
	_level_manager.handle_player_position(position.x)



#===== Physics Handling =====#

func handle_player_physics():
	_state_manager._is_on_floor = is_on_floor()
	_state_manager._is_on_ceiling = is_on_ceiling()
	
	get_movement_force()
	move_and_slide(_velocity*_delta, Vector2(0, -1))


func get_movement_force():
	apply_gravity()
	
	if _state_manager._is_running and _state_manager._can_move:
		apply_walk_force()
	else:
		stop_movement()

func apply_gravity():
	var gravity = _state_manager._gravity
	if _state_manager._is_on_floor:
		if _state_manager._current_action != "jump" and _state_manager._current_action != "hurt":
			_velocity.y = gravity
	else:
		if _state_manager._is_on_ceiling:
			_velocity.y = gravity
		else:
			_velocity.y += gravity

func apply_jump_force():
	_velocity.y = _state_manager._jump_force

func apply_walk_force():
	var facing_direction = _state_manager._facing_direction
	var max_walk_speed = _state_manager._max_walk_speed
	var new_v = abs(_velocity.x) + _state_manager._walk_speed
	if new_v < max_walk_speed:
		_velocity.x = new_v * facing_direction
	else:
		_velocity.x = max_walk_speed * facing_direction

func stop_movement():
	var cur_velocity = abs(_velocity.x)
	if cur_velocity != 0:
		cur_velocity -= _state_manager._stop_force
		if cur_velocity < 0:
			cur_velocity = 0
		_velocity.x = cur_velocity * sign(_velocity.x)


func apply_knockback(knockback):
	_velocity.x += knockback.x
	_velocity.y += knockback.y 

func check_if_landed():
	if _state_manager._is_on_floor:
		set_state_idle()


func change_direction(): # flips the player on the x axis
	var new_scale = get_scale()
	new_scale.x *= -1
	set_scale(new_scale)






# ==== Action Management ==== #

func handle_player_action():
	if _input_handler._inventory_input == true:
		_inventory.toggle_visibility()
	
	var action_input = _input_handler._action_input
	var action_frames = _input_handler._action_frames
	
	var _can_use_action = _state_manager.can_use_action(action_input, action_frames)
	if _can_use_action:
		if action_input == "jump":
			_state_manager.handle_jump_action()
		else:
			_state_manager.handle_attack_action(action_input)


func handle_player_movement_action(): # TODO refactor into _state_manager
	if _state_manager._can_move:
		var movement_input = _input_handler._movement_input_direction
		if movement_input == 0:
			movement_input = _state_manager._facing_direction
			_state_manager._is_running = false
			if _velocity.x == 0 and _state_manager._current_action == "neutral":
				_state_manager.set_state_idle()
		else:
			_state_manager.set_state_move()
			if movement_input != _state_manager._facing_direction: # handle change direction
				change_direction()
	
		_state_manager._facing_direction = movement_input





#===== Collision Management ===== 

func receive_attack(attack, attacker_pos):
	_state_manager.receive_attack(attack, attacker_pos)
	update_hp(_state_manager._current_hp)
	_state_manager.check_if_dead()


func touched_item(item):
	if item.get_parent() is PickableObject:
		item = item.get_parent().get_item_from_container()
	var _is_item_added = _inventory.add_item(item)
	if _is_item_added:
		item.queue_free()


func touched_exit_portal():
	_state_manager._is_touching_exit_portal = true

func stopped_touching_exit_portal():
	_state_manager._is_touching_exit_portal = false





#==== State Interface ====#

func set_state_idle():
	_state_manager.set_state_idle()

func set_state_hurt_recovery():
	_state_manager.set_state_hurt_recovery()





#===== Meta Handling =====#

func fill_hp():
	_state_manager.fill_hp()
	update_hp(_state_manager._current_hp)

func add_hp(amount):
	_state_manager.add_hp(amount)
	update_hp(_state_manager._current_hp)


func increase_max_hp(value): #TODO REFACTOR add scaling bar
	_state_manager.increase_max_hp(value)

func decrease_max_hp(value): #TODO REFACTOR add scaling bar
	_state_manager.decrease_max_hp(value)



func lose_hp(amount):
	_state_manager.lose_hp(amount)
	update_hp(_state_manager._current_hp)
	_state_manager.check_if_dead()




func get_current_attack_values():
	return _weapon.return_attack()









#===== UI Handling =====#

func update_hp(updated_hp):
	_overseer._ui_manager.update_cur_hp_value(updated_hp)
















