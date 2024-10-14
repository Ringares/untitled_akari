extends Area2D

func _input(event: InputEvent) -> void:
	print("_on_clk_shape_area_input")
	if get_parent().has_method("_on_clk_shape_area_input"):
		get_parent()._on_clk_shape_area_input(event)
