extends KinematicBody2D

#==== References ====#
var _player
var _enemy_manager

#==== Components ====#
var _sprite
var _animation_tree 
var _visibility_enabler # TODO maybe remove

var _state_manager
var _physics_manager
var _standard_hitbox
var _attack
var _pickable_object
var _health_bar

#==== Constants ====# 
const _loot_type = 0 # 0:low, 1:mid, 2:high

#==== variables ====# 
var _is_player_in_attack_range



#==== Bootstrap ====#

func _ready():
	set_process(false)
	set_physics_process(false)
	
	_sprite = $Sprite
	_animation_tree = $Sprite/AnimationPlayer
	_visibility_enabler = $VisibilityEnabler2D
	_state_manager = $StandardState
	_physics_manager = $StandardPhysics
	_standard_hitbox = $StandardHitbox
	_health_bar = $EnemyHealthBar
	
	_enemy_manager = get_parent().get_parent()
	_player = get_tree().current_scene.get_node("Player")
	_physics_manager.initialize(self, _player, position)
	_physics_manager._facing_direction = 1
	_state_manager.initialize(self)
	_standard_hitbox.initialize(self)
	_attack = preload("res://Enemies/EnemyList/Slime/SlimeAttack.gd")
	change_direction()


func initialize_pickable_object(item):
	_pickable_object = $PickableObject
	_pickable_object.initialize(item)



#==== State Handling ====#

func _process(delta):
	_state_manager.process_frame()
	handle_state_logic()


func handle_state_logic():
	_state_manager.check_if_can_move()
	_is_player_in_attack_range = _physics_manager.handle_player_range() 
	if not _state_manager._is_knockback \
	and not _state_manager._current_action == "attack":
		if _is_player_in_attack_range[0]:
			_state_manager.set_state_attack()
		elif _state_manager.should_turn_around():
			change_direction()



#==== Physics Handling ====#

func _physics_process(delta):
	var can_move = _state_manager._can_move
	_physics_manager.process_frame(delta, position, can_move)

func change_direction():
	_sprite.scale.x *= -1
	_physics_manager.change_direction()
	_standard_hitbox.scale.x *= -1
	_pickable_object.scale.x *= -1




#==== Attack Handling ====#

func deal_damage(target_hurtbox):
	var attack = _attack.new()
	target_hurtbox.get_parent().receive_attack( \
		attack, 
		position)


func receive_attack(target_hitbox):
	var attack = target_hitbox.get_parent().get_current_attack_values()
	handle_attack(attack)
	_state_manager.handle_damage_state()
	_physics_manager.apply_knockback(target_hitbox, attack, position)


func handle_attack(attack):
	_state_manager._current_hp -= attack._damage
	_state_manager._remaining_damage_until_stunlock  -= attack._damage






