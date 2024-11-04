extends TextureRect

@export var local:String = "en"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color(0.8,0.8,0.8)
	mouse_entered.connect(func():self.modulate = Color(1.3,1.3,1.3))
	mouse_exited.connect(func():self.modulate = Color(0.8,0.8,0.8))
	

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk") or event.is_action_pressed("ui_accept"):
		TranslationServer.set_locale(local)
		GameLog.set_locale(local)
		GameEvents.signal_translation_locale_changed.emit()


func check_focus():
	if has_focus():
		self.modulate = Color(1.3,1.3,1.3)
	else:
		self.modulate =Color(0.8,0.8,0.8)
	
