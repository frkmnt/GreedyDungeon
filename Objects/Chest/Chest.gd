extends StaticBody2D

# Components
var _sprite
var _item


# Meta
var _current_hp




# Bootstrap

func initialize(item):
	_sprite = $Sprite
	
	_item = item
	$ItemContainer.add_child(_item)
	_item.set_collision_mask_bit(6, false)
	_current_hp = 3



# Logic

func on_hurtbox_entered(area):
	_current_hp -= 1
	if _current_hp == 0:
		break_chest()


func break_chest():
	scale = Vector2(1, 1)
	_sprite.texture = null
	set_collision_layer_bit(5, false)
	_item.set_collision_mask_bit(6, true)





