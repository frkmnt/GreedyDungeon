extends KinematicBody2D
class_name PickableObject

#==== Comments ====#
# The code used to make items have physics and become droppable.
# Money doesn't use this class, while chest items do, for example.


#==== Components ====#
var _collision_shape
var _item # item to be spawned
var _pickup_area_shape 
var _pickup_timer 

#==== Variables ====#
var _gravity = 500
var _stop_force = 200
var _velocity = Vector2(0,0)


#==== Bootstrap ====#

func initialize(item):
	item.visible = false
	add_child(item) # sets the sprite on the chest object
	_item = item
	var item_scale = item.scale
	_collision_shape = $CollisionShape2D
	_collision_shape.shape.set_extents( \
		Vector2(_item._object_data.get_sprite().get_size()*0.2))
	_pickup_area_shape = $PickupArea/CollisionShape2D
	_pickup_area_shape.disabled = true


func _ready():
	set_process(false)


#==== Tick ====#

func _process(delta):
	slow_down_horizontal_movement()
	apply_gravity()
	move_and_slide(_velocity*delta, Vector2(0, -1))


#==== Logic ====#

func spawn_item(launch_direction):
	_collision_shape.call_deferred("set_disabled", false)
	_item.visible = true
	select_random_direction(launch_direction)
	initialize_pickup_timer()
	set_process(true)

func initialize_pickup_timer():
	_pickup_timer = Timer.new()
	_pickup_timer.connect("timeout", self, "enable_item_pickup")
	self.add_child(_pickup_timer)
	_pickup_timer.start(0.4)


func enable_item_pickup():
	_pickup_area_shape.call_deferred("set_disabled", false)


#==== Physics ====#

func select_random_direction(launch_direction): # select dir in arc to send item
	var random_angle = floor(rand_range(-45, 45))
	var y_force = tan(deg2rad(random_angle))
	_velocity.y = -8500
	_velocity.x = 6000 * launch_direction


func apply_gravity():
	_velocity.y += _gravity


func slow_down_horizontal_movement():
	var cur_velocity = abs(_velocity.x)
	if cur_velocity != 0:
		cur_velocity -= _stop_force
		if cur_velocity < 0:
			cur_velocity = 0
		_velocity.x = cur_velocity * sign(_velocity.x)


func get_item_from_container():
	queue_free()
	return _item
