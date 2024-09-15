extends Node2D
class_name GridComponent


@export var cell_id: Vector2i

func get_class_name(): return "GridComponent"

func _ready() -> void:
	self.hide()

func show_up(delay:float):
	await get_tree().create_timer(delay * 0.1).timeout
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	self.show()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15).from(Vector2(0.0, 0.0))
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
