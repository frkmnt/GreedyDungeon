extends StaticBody2D

# Components
var _sprite
var _item_container


# Meta
var _current_hp




# Bootstrap

func initialize(powerup):
	_sprite = $Sprite
	_item_container = $ItemContainer
	
	_current_hp = 3
	_item_container.add_child(powerup)



# Logic

func on_hurtbox_entered(area):
	_current_hp -= 1
	if _current_hp <= 0:
		break_chest()


func break_chest():
	scale = Vector2(1, 1)
	_sprite.texture = null
	set_collision_layer_bit(5, false)





