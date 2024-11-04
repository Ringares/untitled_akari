extends CheckButton

const ICONS_8_FOCUS_CHECKMARK_48 = preload("res://assets/img/icon/icons8-checkmark-48.png")
const ICONS_8_DARK_CHECKMARK_48 = preload("res://assets/img/icon/icons8-dark-checkmark-48.png")
const ICONS_8_TICK_48 = preload("res://assets/img/icon/icons8-tick-48.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.signal_daynight_mode_changed.connect(_on_signal_daynight_mode_changed)
	
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
	
	
func set_light_theme():
	self.add_theme_color_override("icon_normal_color", Color("3e3e3e"))
	self.add_theme_color_override("font_color", Color("3e3e3e"))
	self.add_theme_color_override("font_focus_color", Color("3e3e3e"))
	self.add_theme_color_override("icon_focus_color", Color("3e3e3e"))
	self.add_theme_icon_override("unchecked", ICONS_8_DARK_CHECKMARK_48)
	
	
func set_dark_theme():
	self.add_theme_color_override("icon_normal_color", Color("ebede9"))
	self.add_theme_color_override("font_color", Color("ebede9"))
	self.add_theme_color_override("font_focus_color", Color("ebede9"))
	self.add_theme_color_override("icon_focus_color", Color("ebede9"))
	self.add_theme_icon_override("unchecked", ICONS_8_TICK_48)


func _on_signal_daynight_mode_changed():
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()


func check_focus():
	if has_focus():
		self.add_theme_icon_override("unchecked", ICONS_8_FOCUS_CHECKMARK_48)
	else:
		self.add_theme_icon_override("unchecked", [ICONS_8_DARK_CHECKMARK_48, ICONS_8_TICK_48][GameLog.get_daynight_mode()])
	
