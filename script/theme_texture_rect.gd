extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.signal_daynight_mode_changed.connect(_on_signal_daynight_mode_changed)
	
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
	
	
func set_light_theme():
	self.modulate = Color("3e3e3e")
	
func set_dark_theme():
	self.modulate = Color("ebede9")


func _on_signal_daynight_mode_changed():
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
