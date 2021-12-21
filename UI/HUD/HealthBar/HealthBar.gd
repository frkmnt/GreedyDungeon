extends Node

#==== Components ====#
var _health_bar_label
var _health_bar_foreground


#==== Bootstrap ====#

func initialize():
	_health_bar_label = $TotalHealthLabel
	_health_bar_foreground = $HealthBarForeground

func initialize_with_player(max_hp):
	self.max_value = max_hp
	self.value = max_hp
	_health_bar_foreground.max_value = max_hp
	_health_bar_foreground.value = max_hp
	update_health_label()


#==== Tick Handling ====#

func _process(delta):
	if self.value != _health_bar_foreground.value:
		self.value = lerp(self.value, _health_bar_foreground.value, 0.1)
		if(self.value - _health_bar_foreground.value <= 0.5):
			self.value = _health_bar_foreground.value



#==== UI Interaction ====#

func set_max_health(max_health):
	self.max_value = max_health
	update_health_label()
	

func set_cur_health(new_hp):
	_health_bar_foreground.value = new_hp
	if(_health_bar_foreground.value > self.value):
		self.value = new_hp
	update_health_label()

func update_health_label():
	var text = str(_health_bar_foreground.value) + " / " + str(self.max_value)
	_health_bar_label.text = text
