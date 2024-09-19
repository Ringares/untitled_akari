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
		#level_root.scale = Vector2.ONE
		var size = await level_root.adjust_position_scale()
		print("PlaceholdRect.custom_minimum_size", size)
		#%PlaceholdRect.custom_minimum_size = size
		#%PlaceholdRect.queue_redraw()
		%PlaceholdRect.custom_minimum_size = size
		%ProgressBar.show()
		#%PlaceholdRect.set_size(Vector2.ZERO)
		for child in level_root.get_children():
			child.set("interactable", true)
			
			#if child is Ground and (child.cell_id.x + child.cell_id.y) % 2 ==0:
				#child.modulate = Color("#eeeeee")


func _process(delta: float) -> void:
	get_window().title = "Untitled Akari Game / FPS: " + str(Engine.get_frames_per_second())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func check_win_condition():
	var is_win = true
	var is_all_lighted = true
	for i in get_tree().get_nodes_in_group("ground"):
		if not (i as Ground).is_lighted:
			is_win = false
			is_all_lighted = false
			print("check_win_condition", i, is_win)
			break
	
	print("is_all_lighted: ", is_all_lighted)
	for i in get_tree().get_nodes_in_group("obstacle_num"):
		(i as ObstacleNum).stop_notify()
		if not (i as ObstacleNum).is_satisfied:
			is_win = false
			if is_all_lighted:
				i.get_parent().move_child(i, i.get_parent().get_child_count(-1))
				(i as ObstacleNum).notify()
			print("check_win_condition", i, is_win)
	
	for i in get_tree().get_nodes_in_group("akari"):
		(i as Akari).stop_notify()
		if not (i as Akari).is_satisfied:
			is_win = false
			if is_all_lighted:
				i.get_parent().move_child(i, i.get_parent().get_child_count(-1))
				(i as Akari).notify()
				
			print("check_win_condition", i, is_win)

	
	print("Level Win: ", is_win)
	if is_win:
		$UILayer/MarginContainer/Label.show()
	else:
		$UILayer/MarginContainer/Label.hide()
