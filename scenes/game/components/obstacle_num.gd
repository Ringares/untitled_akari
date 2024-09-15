@tool
extends Obstacle
class_name ObstacleNum

func get_class_name(): return "ObstacleNum"

@onready var notify_anim_player: AnimationPlayer = $NotifyAnimPlayer
var around_akari = []

@export var hint_num = 5:
	set(value):
		hint_num = value
		if label:
			if value == 5:
				label.text = ""
			else:
				label.text = str(value)
		
		
@onready var label: Label = $Label

var is_satisfied:bool:
	get():
		if hint_num == 5:
			return true
		elif around_akari.size() == hint_num:
			return true
		else:
			return false


func _ready() -> void:
	super()
	if hint_num == 5:
		label.text = ""
	else:
		label.text = str(hint_num)


func notify():
	if notify_anim_player.is_playing():
		notify_anim_player.stop()
	notify_anim_player.play("notify")

func stop_notify():
	notify_anim_player.stop()
	notify_anim_player.play("RESET")
	

func _on_akari_check_area_area_entered(area: Area2D) -> void:
	around_akari.append(area)


func _on_akari_check_area_area_exited(area: Area2D) -> void:
	around_akari.erase(area)
