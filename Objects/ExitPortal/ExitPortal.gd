extends Node

#==== Constants Management ====#
const _TYPE = "exit_portal"



func get_type():
	return _TYPE


#==== Collision Management ====#

func player_touched_portal(player_collision):
	player_collision.get_parent().touched_exit_portal()

func player_exited_portal(player_collision):
	player_collision.get_parent().stopped_touching_exit_portal()
