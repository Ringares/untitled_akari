extends CanvasLayer



func _on_main_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/menu/main_menu.tscn")


func _on_light_mode_button_pressed() -> void:
	var new_mode = DisplayMode.switch_mode()
	
	if new_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")
