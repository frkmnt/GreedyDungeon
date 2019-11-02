extends Node


var animation_player


func _ready():
	animation_player = get_parent().get_parent().animation_player




func idle(): #also triggered when an animation finishes
	animation_player.play("idle")


func move():
	animation_player.play("move")


func jump():
	animation_player.play("jump")

