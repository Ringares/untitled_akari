extends CanvasLayer
class_name BGLayer

func _ready() -> void:
	GameEvents.signal_daynight_mode_changed.connect(_on_signal_daynight_mode_changed)
	
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()

func set_light_theme():
	$LightColorRect.show()
	$DarkColorRect.hide()
		
func set_dark_theme():
		$LightColorRect.hide()
		$DarkColorRect.show()


func _on_signal_daynight_mode_changed():
	match GameLog.get_daynight_mode():
		0:set_light_theme()
		1:set_dark_theme()
