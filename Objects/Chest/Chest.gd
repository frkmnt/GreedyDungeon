extends StaticBody2D

#==== Components ====#
var _sprite
var _pickable_object 


#==== Variables ====#
var _current_hp



#==== Bootstrap ====#

func initialize(item):
	_sprite = $Sprite
	_pickable_object = $PickableObject
	
	_pickable_object.initialize(item)
	_current_hp = 3



# Logic

func on_hurtbox_entered(area): # TODO add shake effect
	_current_hp -= 1
	if _current_hp == 0:
		var launch_direction = 1
		if area.get_parent().transform.x < self.transform.x:
			launch_direction = -1
		break_chest()
		_pickable_object.spawn_item(launch_direction)
	else:
		play_damage_animation()


func break_chest():
	scale = Vector2(1, 1) # TODO dafuq?
	_sprite.texture = null


func play_damage_animation(): # TODO implement
	pass



