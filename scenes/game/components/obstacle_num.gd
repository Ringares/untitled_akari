extends Obstacle
class_name ObstacleNum


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


func _on_akari_check_area_area_entered(area: Area2D) -> void:
	around_akari.append(area)


func _on_akari_check_area_area_exited(area: Area2D) -> void:
	around_akari.erase(area)
