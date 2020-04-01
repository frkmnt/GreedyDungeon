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
var _shield_sprites

#==== Variables ====#
var _is_removing = false # true when is currently self removing 
var _needs_to_be_removed = false 





#==== Bootstrap ====#

func initialize(target):
	_target = target
	_shield_sprites = $ShieldSprites
	_shield_sprites.playing = true

#==== Stack Handling ====#
func on_stack(new_shield):
	_is_removing = false



#==== On Receive Hit ====#

func on_receive_attack(attack):
	if _is_removing == false:
		attack._damage = 0
		end_modifier()
		return attack



#==== Removal ====#

func end_modifier():
	_is_removing = true
	_shield_sprites.play("ReceivedAttack")
	_needs_to_be_removed = true
	

func on_animation_finished():
	if _is_removing == true:
		_target._state_manager.remove_modifier(self)
		queue_free()


