extends GridComponent
class_name Ground

const AKARI = preload("res://scenes/game/components/akari.tscn")
const MARKER = preload("res://scenes/game/components/marker.tscn")

@onready var lighted_ground: Sprite2D = $LightedGround
@onready var normal_ground: Sprite2D = $NormalGround

var marker: Marker
var akari: Akari
var is_lighted = false
var passed_lights = []


func left_clk():
	if marker:
		marker.queue_free()
		marker = null
		
	if akari == null:
		akari = AKARI.instantiate()
		add_child(akari)
	else:
		akari.queue_free()
		akari = null


func right_clk():
	if akari:
		akari.queue_free()
		akari = null
		
	if marker == null:
		marker = MARKER.instantiate()
		add_child(marker)
	else:
		marker.queue_free()
		marker = null


func light_up():
	is_lighted = true
	lighted_ground.show()
	normal_ground.hide()


func light_off():
	is_lighted = false
	lighted_ground.hide()
	normal_ground.show()


func _on_area_2d_area_entered(area: Area2D) -> void:
	passed_lights.append(area)
	light_up()


func _on_area_2d_area_exited(area: Area2D) -> void:
	passed_lights.erase(area)
	if passed_lights.size() == 0:
		light_off()
