extends Node2D

#==== References ====#
var _camera 
var _enemy_manager


# ==== Components ==== #
var _map_generator
var _money_generator
var _room_container

var _limit_left
var _limit_right


# ==== Variables ==== #

var _instantiated_rooms = [] # nº0 is the newest

var _total_rooms_instanced = 0
var _room_spawn_position = 800 # pos player has to reach to spawn room

var _boss_max_camera_distance = 0
var _is_currently_boss_battle = false


# ==== Boostrap ==== #

func initialize():
	_camera = get_parent()._ui_manager._camera
	_enemy_manager = get_parent()._enemy_manager
	_room_container = $RoomContainer
	_limit_left = $PlayerLimitLeft
	_limit_right = $ PlayerLimitRight
	initialize_map_generator()
	spawn_starter_rooms()


func initialize_map_generator():
	_money_generator = preload("res://Level/Generation/MoneyGenerator.gd").new()
	_money_generator.initialize()
	_map_generator = $MapGenerator
	_map_generator.initialize(self)


func spawn_starter_rooms():
	var room_container = get_child(1)
	print(room_container)
	
	var room_instance = _map_generator.spawn_first_room()
	_instantiated_rooms.append(room_instance)

	room_instance = _map_generator.spawn_starter_room()
	_instantiated_rooms.append(room_instance)
	_map_generator.place_room(room_instance, 400)
	_map_generator.spawn_random_enemy_in_room(room_instance)
	room_container.add_child(room_instance)

	room_instance = _map_generator.spawn_starter_room()
	_instantiated_rooms.append(room_instance)
	_map_generator.place_room(room_instance, 800)
	_map_generator.spawn_random_enemy_in_room(room_instance)
	room_container.add_child(room_instance)





# ==== Logic ==== #

func handle_player_position(p_pos):
	handle_camera_position(p_pos)
	handle_level_spawn(p_pos)
	



# ==== Camera Component Interface ==== #

func handle_camera_position(p_pos):
	var distance_player_to_camera = p_pos - _camera.position.x
	var move_offset = distance_player_to_camera - 200
	if move_offset > 0: #REFACTOR possibly causes camera stutter
		move_offset = int(move_offset)
		if _is_currently_boss_battle:
			var new_cam_pos = _camera.position.x + move_offset
			if new_cam_pos <= _boss_max_camera_distance:
				_camera.position.x = new_cam_pos
				_limit_left.position.x += move_offset
				_limit_right.position.x += move_offset
			else:
				_camera.position.x = _boss_max_camera_distance
		else:
			_camera.position.x += move_offset
			_limit_left.position.x += move_offset
			_limit_right.position.x += move_offset
		_camera.align()





# ==== Map Generator Component Interface ==== #

func handle_level_spawn(p_pos):
	if p_pos >= _room_spawn_position:
		#_enemy_manager.update_despawn_position(_room_spawn_position - 500)
		_room_spawn_position = _room_spawn_position + 400
		_map_generator._semaphore.post()


func remove_oldest_room():
	var floor_to_remove = _instantiated_rooms.pop_front()
	floor_to_remove.queue_free()


func on_boss_room_spawn():
	_boss_max_camera_distance = _room_spawn_position















