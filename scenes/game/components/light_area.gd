extends Area2D
class_name AkariLight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.debug_color = Color(randf(),randf(), randf(), 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
