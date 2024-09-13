extends Obstacle
class_name ObstacleNum

@export var hint_num = 5:
	set(value):
		hint_num = value
		if value == 5:
			label.text = ""
		else:
			label.text = str(value)
		
		
@onready var label: Label = $Label
