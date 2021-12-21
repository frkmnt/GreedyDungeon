extends Node

#==== Constants ====#
const _id = 3
const _modifier_ids = [3] # received hit
const _name = "Shield"
const _description = "Absorbs the next hit."
const _priority = 0

#==== References ====#
var _target 

#==== Components ====#
var _despawn_timer
var _shield_sprites

#==== Variables ====#
var _is_removing = false # in case the end animation hasn't finished
var _needs_to_be_removed = false 
var _despawn_duration = 0

var _cur_hp = 1



#==== Bootstrap ====#

func initialize_values(total_hp):
	_cur_hp = total_hp

func initialize(target):
	_target = target
	_shield_sprites = $ShieldSprites
	_shield_sprites.playing = true

func initialize_timeout_timer(duration):
	if not is_instance_valid(_despawn_timer):
		_despawn_duration = duration
		_despawn_timer = Timer.new()
		_despawn_timer.connect("timeout", self, "remove_modifier")
		_despawn_timer.set_one_shot(true)
		add_child(_despawn_timer)
		_despawn_timer.start(duration)
	else:
		if _despawn_timer.get_time_left() < duration:
			_despawn_timer.start(duration)



#==== Common Components ====#

func on_stack(new_shield):
	_is_removing = false
	if _despawn_duration != null:
		initialize_timeout_timer(_despawn_duration)


func remove_modifier():
	_is_removing = true
	_shield_sprites.play("ReceivedAttack")
	_needs_to_be_removed = true



#==== Specific Components ====#

func on_receive_attack(attack):
	if _is_removing == false:
		_cur_hp -= 1
		if _cur_hp <= 0:
			attack._damage = 0
			remove_modifier()
			return attack


func on_animation_finished():
	if _is_removing == true:
		_target._state_manager.remove_modifier(self)
		queue_free()


