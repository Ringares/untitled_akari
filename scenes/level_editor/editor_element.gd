extends TextureRect
class_name EditorElement

@export var scene : PackedScene


func _ready() -> void:
	self.mouse_entered.connect(func():
		self.modulate = Color(1.2,1.2,1.2)
		)
	self.mouse_exited.connect(func():
		self.modulate = Color.WHITE
		)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk"):
		EditorEvents.signal_element_selected.emit(scene)
