extends Area2D
class_name AkariLight

@onready var timer: Timer = $Timer
var spread_speeds = [1,2,]
var spread_times = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.debug_color = Color(randf(),randf(), randf(), 1.0)

func stop_spread(scale_x:int):
	self.scale.x = scale_x
	timer.stop()

func start_spread():
	$CollisionShape2D.disabled = false
	timer.start()

func _on_timer_timeout() -> void:
	self.scale.x += 1
	var factor = spread_speeds[spread_times] if spread_times < spread_speeds.size() else spread_speeds[-1]
	timer.wait_time = 0.1 / factor
	spread_times += 1
	if self.scale.x > 20:
		timer.stop()
