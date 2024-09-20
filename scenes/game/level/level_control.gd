extends Node2D
class_name LevelControl

@export var packed_level:PackedScene:
	set(value):
		if value != packed_level:
			print("level_data_changed")
		packed_level = value
		init_level()
		
var current_level_id_str:String = ""
		
		
const PAUSE_MENU = preload("res://scenes/menu/pause_menu.tscn")
const LEVEL_SELECTOR = preload("res://scenes/game/level_selector.tscn")


@onready var bg_canvas_layer: BGLayer = %BGCanvasLayer
@onready var level_container: Node2D = %LevelContainer
var progress_value = 0.0
var PROGRESS_SPEED = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.signal_check_win_condition.connect(check_win_condition)
	var daynight_mode = GameLog.get_daynight_mode()
	%Label.text = ""
	%NextButton.hide()
	%CenterContainer.hide()
	%LevelIDLabel.text = current_level_id_str
	%CollectionLabel.text = str(GameLevelLog.get_passed_levels().size())
	
	if daynight_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")
	
	init_level()


func init_level():
	
	if level_container !=null and packed_level !=null:
		var level_root = packed_level.instantiate() as LevelRoot
		level_container.add_child(level_root)
		#level_root.scale = Vector2.ONE
		var size = await level_root.adjust_position_scale()
		print("PlaceholdRect.custom_minimum_size", size)
		%PlaceholdRect.custom_minimum_size = size
		for child in level_root.get_children():
			child.set("interactable", true)
	
		%ProgressBar.custom_minimum_size.x = size.x
	%CenterContainer.show()


func _process(delta: float) -> void:
	get_window().title = "Untitled Akari Game / FPS: " + str(Engine.get_frames_per_second())
	var temp_v = lerp(%ProgressBar.value, progress_value, PROGRESS_SPEED * delta)
	temp_v = snappedf(temp_v, 0.01)
	%ProgressBar.value = temp_v
	#print(PROGRESS_SPEED * delta, " ",  %ProgressBar.value, "->", progress_value, ", ", temp_v)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("next_level"):
		GameEvents.signal_level_advance.emit()


func check_win_condition():
	var is_win = true
	var is_all_lighted = true
	var cells_count = 0.
	var unlighted_cells_count = 0.
	for i in get_tree().get_nodes_in_group("ground"):
		cells_count += 1
		if not (i as Ground).is_lighted:
			unlighted_cells_count += 1
			is_win = false
			is_all_lighted = false
			print("check_win_condition", i, is_win)
	
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
	
	# progress
	progress_value = (1 - (unlighted_cells_count / cells_count)) * 100
	
	print("Level Win: ", is_win)
	if is_win:
		%Label.text = "Solved"
		%NextButton.show()
		%NextButtonPlaceHold.hide()
	else:
		%Label.text = ""
		%NextButton.hide()
		%NextButtonPlaceHold.show()


func _on_reset_button_pressed() -> void:
	GameEvents.signal_level_reset.emit()


func _on_next_button_pressed() -> void:
	GameEvents.signal_level_advance.emit()


func _on_light_mode_button_pressed() -> void:
	var new_mode = DisplayMode.switch_mode()
	
	if new_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")


func _on_menu_button_pressed() -> void:
	InGameMenuController.open_menu(PAUSE_MENU, get_viewport())


func _on_level_select_button_pressed() -> void:
	add_child(LEVEL_SELECTOR.instantiate())
