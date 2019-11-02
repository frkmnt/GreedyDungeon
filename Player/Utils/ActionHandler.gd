extends Node

var hero_manager
var input_handler
var movement_handler
var weapon1
var weapon2


#==== STATE CONTROLLER ====#

var is_on_wall = false
var is_on_floor = false
var is_on_ceiling = false

var is_stoping = false
var is_running = false
var current_action = "neutral" # neutral, jump, attack, skill
var facing_direction = "right" # or left

var is_dead = false
var is_invulnerable = false
var is_knockback = false




# Called when the node enters the scene tree for the first time.
func _ready():
	hero_manager = get_parent()
	input_handler = hero_manager.input_handler
	
	movement_handler = get_child(0)
	weapon1 = get_child(1)
	weapon2 = get_child(2)





func match_state():
	
	if not is_knockback:
		
		var action_input = hero_manager.input_handler.action_input
		
		is_on_floor = hero_manager.is_on_floor()
		is_on_ceiling = hero_manager.is_on_ceiling()
		is_on_wall = hero_manager.is_on_wall()
		
		if is_on_floor:
			hero_manager.number_of_jumps = 0
		
		print("cur action ", current_action)
		if current_action == "neutral":
			match action_input:
				"jump":
					movement_handler.jump()
				
				"attack":
					pass
					weapon1.attack()
				
				"skill":
					pass
					weapon2.attack()
				
		
		


func handle_movement():
	pass









