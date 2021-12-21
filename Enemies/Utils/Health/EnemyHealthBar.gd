extends ProgressBar

#==== Components ====#
var _health_bar_foreground



#==== Bootstrap ====#

func initialize(max_hp):
	_health_bar_foreground = $EnemyHealthBarForeground
	initialize_health_values(max_hp)


func initialize_health_values(max_hp):
	self.max_value = max_hp # don't update this value
	self.value = max_hp 
	_health_bar_foreground.max_value = max_hp
	_health_bar_foreground.value = max_hp




#==== Tick Handling ====#

func process_frame():
	handle_visibility()
	if self.value != _health_bar_foreground.value:
		self.value = lerp(self.value, _health_bar_foreground.value, 0.1)
		if(self.value - _health_bar_foreground.value <= 0.5):
			self.value = _health_bar_foreground.value

	#or
	#$ProgressBar2.value -= 0.8
	#if($ProgressBar2.value <= value):
	#	$ProgressBar2.value = value
	#	set_process(false)



#==== Logic ====#

func set_health_bar_value(new_hp):
	_health_bar_foreground.value = new_hp
	if(_health_bar_foreground.value > self.value):
		self.value = new_hp

func is_health_bar_full():
	var is_full = false
	if self.value == self.max_value:
		is_full = true
	return is_full



#==== Visibility ====#

func handle_visibility(): #TODO add fade in, fade out
	if is_health_bar_full():
		visible = false
	else:
		visible = true
