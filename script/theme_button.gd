extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.signal_daynight_mode_changed.connect(_on_signal_daynight_mode_changed)
	
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
	
	
func set_light_theme():
	self.add_theme_color_override("icon_normal_color", Color("3e3e3e"))
	self.add_theme_color_override("font_color", Color("3e3e3e"))
	#self.add_theme_color_override("font_focus_color", Color("3e3e3e"))
	#self.add_theme_color_override("icon_focus_color", Color("3e3e3e"))
	
	
func set_dark_theme():
	self.add_theme_color_override("icon_normal_color", Color("ebede9"))
	self.add_theme_color_override("font_color", Color("ebede9"))
	#self.add_theme_color_override("font_focus_color", Color("ebede9"))
	#self.add_theme_color_override("icon_focus_color", Color("ebede9"))



func _on_signal_daynight_mode_changed():
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()


func _on_pressed() -> void:
	var new_mode = DisplayMode.switch_mode()
	
	if new_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")
