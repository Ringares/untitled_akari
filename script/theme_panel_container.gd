extends PanelContainer

@export var dark_color:Color = Color("3e3e3e")
@export var light_color:Color = Color("ebede9")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.signal_daynight_mode_changed.connect(_on_signal_daynight_mode_changed)
	
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
	
	
func set_light_theme():
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = light_color
	self.add_theme_stylebox_override("panel", new_stylebox)
	
	
func set_dark_theme():
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = dark_color
	self.add_theme_stylebox_override("panel", new_stylebox)


func _on_signal_daynight_mode_changed():
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
