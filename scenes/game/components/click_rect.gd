extends ColorRect


func _gui_input(event: InputEvent) -> void:
	if get_parent().has_method("_on_clk_rect_gui_input"):
		get_parent()._on_clk_rect_gui_input(event)
