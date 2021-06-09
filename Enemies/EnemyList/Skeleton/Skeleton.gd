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





#==== Bootstrap ====#

func _ready():
	set_process(false)
	set_physics_process(false)
	_enemy_manager = get_parent().get_parent()
	
	_sprite = $Sprite
	_animation_tree = $Sprite/AnimationPlayer
	_visibility_enabler = $VisibilityEnabler2D
	
#	_despawn_pos_x = _enemy_manager._despawn_pos_x
#	_despawn_pos_y = _enemy_manager._despawn_pos_y
	set_scale(Vector2(-0.8, 0.8))
	
	_player = get_tree().current_scene.get_node("Player")
	_state_manager = $StandardState
	_physics_manager = $StandardPhysics
	_physics_manager.initialize(self, _player, position)
	_state_manager.initialize(self)
	_standard_hitbox = $StandardHitbox
	_standard_hitbox.initialize(self)
	_attack = preload("res://Enemies/EnemyList/Skeleton/SkeletonAttack.gd")

func initialize_pickable_object(item):
	_pickable_object = $PickableObject
	_pickable_object.initialize(item)


#==== State Handling ====#

func _process(delta):
	_state_manager.process_frame(delta)



#==== Physics Handling ====#

func _physics_process(delta):
	var can_move = _state_manager.can_move()
	_physics_manager.process_frame(delta, position, can_move)



#==== Attack Handling ====#

func deal_damage(target_hurtbox):
	target_hurtbox.get_parent().receive_attack( \
		_attack.new(), 
		position)


func receive_attack(target_hitbox):
	var attack = target_hitbox.get_parent().get_current_attack_values()
	_state_manager.receive_attack(target_hitbox, attack)
	_physics_manager.apply_knockback(target_hitbox, attack, position)









