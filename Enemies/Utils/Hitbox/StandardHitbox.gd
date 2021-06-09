extends Node

#==== Class Comments ====#
# This class handles collisions and informs the parent.
# Its shapes are handled by the Animation Tree.


#==== References ====#
var _parent


#==== Bootstrap ====#

func initialize(parent):
	_parent = parent


#==== Logic ====#

func on_hitbox_entered(target_hurtbox): # deal damage
	_parent.deal_damage(target_hurtbox)

func on_hurtbox_entered(target_hitbox): # receive attack
	_parent.receive_attack(target_hitbox)

