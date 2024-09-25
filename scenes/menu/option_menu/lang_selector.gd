extends TextureRect

@export var local:String = "en"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func():self.modulate = Color(1.2,1.2,1.2))
	mouse_exited.connect(func():self.modulate = Color(1.0,1.0,1.0))
	

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk"):
		TranslationServer.set_locale(local)
		GameLog.set_locale(local)
