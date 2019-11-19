extends Node2D

# This script acts as a thread and generates levels as a background process.

# Constants
const _MAP_HEIGHT = 25
const _MAP_WIDTH = 25
const _ASPECT_RATIO = 16
const _FLOOR_OFFSET = _MAP_HEIGHT * _ASPECT_RATIO
const _MAP_RATIO = _ASPECT_RATIO * _MAP_WIDTH


# Components
var _level_manager
var _money_generator
var _room_container
var _enemy_manager


# Prefabs
var _room_prefabs = [] # The first room is index 0
var _boss_room_prefabs = []
var _exit_portal


# Variables
var _current_room_x_position = 0
var _current_nr_of_rooms_generated = 0
var _is_busy = false
var _is_boss_room = false


# Thread Variables
var _mutex
var _semaphore
var _thread



# Boostrap

func initialize(level_manager): 
	_level_manager = level_manager
	_enemy_manager = level_manager.get_parent().get_node("EnemyManager")
	_money_generator = preload("res://Level/Generation/MoneyGenerator.gd").new()
	_money_generator.initialize()
	_room_container = get_parent().get_child(1)
	load_object_prefabs()
	inititalize_floors()
	initialize_boss_floors()
	initialize_thread()


func load_object_prefabs():
	_exit_portal = preload("res://Objects/ExitPortal/ExitPortal.tscn")
	

func inititalize_floors():
	var first_room = preload("res://Level/Rooms/RoomList/TemplateRoom.tscn")
	_room_prefabs.append(first_room)
	
	var directory = Directory.new()
	directory.open("res://Level/Rooms/RoomList")
	directory.list_dir_begin(true)
	
	var room_prefab
	var file_name = directory.get_next()
	while (file_name != ""):
		print("Loading floor: " + directory.get_current_dir() + "/" + file_name)
		if file_name != "TemplateRoom.tscn":
			room_prefab = load(directory.get_current_dir() + "/" + file_name)
			_room_prefabs.append(room_prefab)
		file_name = directory.get_next()


func initialize_boss_floors():
	var directory = Directory.new()
	directory.open("res://Level/Rooms/BossRoomList")
	directory.list_dir_begin(true)
	
	var room_prefab
	var file_name = directory.get_next()
	while (file_name != ""):
		print("Loading floor: " + directory.get_current_dir() + "/" + file_name)
		if file_name != "TemplateRoom.tscn":
			room_prefab = load(directory.get_current_dir() + "/" + file_name)
			_boss_room_prefabs.append(room_prefab)
		file_name = directory.get_next()



func initialize_thread():
	_mutex = Mutex.new()
	_semaphore = Semaphore.new()
	_thread = Thread.new()
	_thread.start(self, "generate_new_room")





# Thread

func generate_new_room(data): # The threaded function
	while true:
		_semaphore.wait() # Wait until posted.
		_mutex.lock()
		_is_busy = true
		
		var room_instance = spawn_random_room()
		place_room( \
			room_instance, 700+_level_manager.get_oldest_room_offset())
		_level_manager.remove_oldest_room() 
		_level_manager._instantiated_rooms.append(room_instance)
		
		if _is_boss_room:
			spawn_boss_in_room(room_instance)
		else:
			spawn_random_enemy_in_room(room_instance)
		
		_room_container.add_child(room_instance)
		
		_is_busy = false
		_mutex.unlock()
		





# Logic

func spawn_first_room():
	var room_instance = _room_prefabs[0].instance()
	room_instance.initialize()
	_room_container.add_child(room_instance)
	decorate_room(room_instance)
	print("Spawned the first room.")
	return room_instance


func spawn_starter_room(): # no chests or portals
	_current_nr_of_rooms_generated += 1
	var room_instance
	room_instance = get_random_room().instance()
	room_instance.initialize()
	decorate_room(room_instance)
	_money_generator.generate_loot_in_room(room_instance, _current_nr_of_rooms_generated)
	return room_instance





func spawn_random_room():
	_current_nr_of_rooms_generated += 1
	_is_boss_room = false
	
	var room_instance
	if _current_nr_of_rooms_generated % 10 == 1: # boss room
		room_instance = spawn_boss_room()
		_is_boss_room = true
	else:
		room_instance = spawn_normal_room()
	
	return room_instance


func spawn_normal_room():
	var room_instance
	room_instance = get_random_room().instance()
	room_instance.initialize()
	decorate_room(room_instance)
	_money_generator.generate_loot_in_room(room_instance, _current_nr_of_rooms_generated)
	if _current_nr_of_rooms_generated % 10 == 0: # portal room
		generate_exit_portal(room_instance)
	return room_instance


func spawn_boss_room():
	var room_instance
	room_instance = get_random_boss_room().instance()
	room_instance.initialize()
	decorate_room(room_instance)
	return room_instance




# Room Randomizers

func get_random_room():
	randomize()
	var random_room_index = floor(rand_range(1, _room_prefabs.size()))
	print("Generating Room ", random_room_index+1, ".\n")
	return _room_prefabs[random_room_index]


func get_random_boss_room():
	var random_room_index = 0
	print("Generating Boss Room ", random_room_index+1, ".\n")
	return _boss_room_prefabs[random_room_index]



func generate_exit_portal(room_instance):
	var portal_instance = _exit_portal.instance()
	room_instance.add_child(portal_instance)
	portal_instance.position = room_instance._PORTAL_POSITION
	print("portal position ", portal_instance.position)


func place_room(room_instance, room_x_position):
	room_instance.position.x = room_x_position


func spawn_random_enemy_in_room(room_instance):
	var enemy_spawn_positions = room_instance._ENEMY_POSITIONS
	randomize()
	
	for enemy_position in enemy_spawn_positions:
		var coordinates = enemy_position
		coordinates.x = room_instance.position.x + coordinates.x
		 
		var enemy_prefab = _enemy_manager._enemy_spawner.get_random_enemy().instance()
		enemy_prefab.position = coordinates
		_enemy_manager.add_enemy(enemy_prefab)


func spawn_boss_in_room(room_instance):
	_level_manager._is_currently_boss_battle = true
	room_instance._has_boss = true
	var boss_instance = room_instance.get_child(2)
	boss_instance.position.x += room_instance.position.x
	room_instance.remove_child(boss_instance)
	_enemy_manager.add_enemy(boss_instance)


#====MAP DECORATION ====#

func decorate_room(room_instance):
	for tile in room_instance._tilemap.get_used_cells():
		randomize()
		var probability = floor(rand_range(0, 100))
		if probability >= 74:
			var tile_type = find_type_of_tile(room_instance._tilemap, tile)
			if tile_type != "PILLAR":
				var tile_decoration = choose_random_tile_of_type(tile_type)
				room_instance._tilemap.set_cellv(tile, tile_decoration)


func find_type_of_tile(tilemap, tile_coords):
	var tile_type_id = tilemap.get_cellv(tile_coords)
	
	if tile_type_id == -1:
		return "BLANK"
	elif tile_type_id >= 0 and tile_type_id < 7:
		return "FLOOR"
	elif tile_type_id >= 7 and tile_type_id < 15:
		return "WALL"
	elif tile_type_id >= 15 and tile_type_id < 23:
		return "BACKGROUND"
	else:
		return "BLANK"


func choose_random_tile_of_type(type):
	var min_index = -1
	var max_index = -1
	
	match type:
		"BLANK":
			min_index = -1
			max_index = -1
		"FLOOR":
			min_index = 0
			max_index = 6
		"WALL":
			min_index = 7
			max_index = 14
		"BACKGROUND":
			min_index = 15
			max_index = 22
	          
	randomize()
	var random_tile = floor(rand_range(min_index, max_index))
	return random_tile





