extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _gui_input(event: InputEvent) -> void:
	if get_parent().has_method("_on_clk_rect_gui_input"):
		get_parent()._on_clk_rect_gui_input(event)
