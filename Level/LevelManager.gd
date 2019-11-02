extends Node2D


#Variables
var _map_generator
var _room_container

var _instantiated_rooms = [] # nº0 is the newest

var _current_room = 1
var _total_rooms_instanced = 0



# Boostrap

func initialize():
	_room_container = $RoomContainer
	initialize_map_generator()
	spawn_starter_rooms()


func initialize_map_generator():
	_map_generator = $MapGenerator
	_map_generator.initialize(self)


func spawn_starter_rooms():
	var room_container = get_child(1)
	print(room_container)
	
	var room_instance = _map_generator.spawn_first_room()
	_instantiated_rooms.append(room_instance)
	
	room_instance = _map_generator.spawn_random_floor()
	_instantiated_rooms.append(room_instance)
	_map_generator.place_room(room_instance, 400)
	_map_generator.spawn_random_enemy_in_room(room_instance)
	room_container.add_child(room_instance)
	
	room_instance = _map_generator.spawn_random_floor()
	_instantiated_rooms.append(room_instance)
	_map_generator.place_room(room_instance, 800)
	_map_generator.spawn_random_enemy_in_room(room_instance)
	room_container.add_child(room_instance)





# Logic

func update_room_positions(speed):
	for room in _instantiated_rooms:
		room.position = Vector2(room.position.x-speed, 0)
	if does_room_need_to_be_spawned():
		add_room()


func does_room_need_to_be_spawned():
	var b = false
	if get_oldest_room_position() < -500 \
	and not _map_generator._is_busy:
		b = true
	return b


func add_room():
	_map_generator._semaphore.post()





func remove_oldest_room():
	var floor_to_remove = _instantiated_rooms.pop_front()
	floor_to_remove.queue_free()


func get_oldest_room_position():
	return _instantiated_rooms[0].position.x


func get_oldest_room_offset():
	return _instantiated_rooms[0].position.x +500

