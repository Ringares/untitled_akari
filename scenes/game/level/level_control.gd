extends Node2D
class_name LevelControl

@export var packed_level:PackedScene
@onready var level_container: Node2D = %LevelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.signal_check_win_condition.connect(check_win_condition)
	
	if packed_level !=null:
		var level_root = packed_level.instantiate() as LevelRoot
		level_container.add_child(level_root)
		level_root.scale = Vector2.ONE
		level_root.adjust_position_scale()
		
		for child in level_root.get_children():
			child.set("interactable", true)
			
			#if child is Ground and (child.cell_id.x + child.cell_id.y) % 2 ==0:
				#child.modulate = Color("#eeeeee")


func _process(delta: float) -> void:
	get_window().title = "Untitled Akari Game / FPS: " + str(Engine.get_frames_per_second())
	


func check_win_condition():
	var is_win = true
	for i in get_tree().get_nodes_in_group("ground"):
		if not (i as Ground).is_lighted:
			is_win = false
			print("check_win_condition", i, is_win)
			break

	for i in get_tree().get_nodes_in_group("obstacle_num"):
		if not (i as ObstacleNum).is_satisfied:
			is_win = false
			print("check_win_condition", i, is_win)
			break
	
	for i in get_tree().get_nodes_in_group("akari"):
		if not (i as Akari).is_satisfied:
			is_win = false
			print("check_win_condition", i, is_win)
			break
	
	print("Level Win: ", is_win)
	if is_win:
		$UILayer/Label.show()
	else:
		$UILayer/Label.hide()
