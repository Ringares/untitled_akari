extends Node2D
class_name LevelControl

const LEVEL_ROOT = preload("res://scenes/game/level/level_root.tscn")
const GROUND = preload("res://scenes/game/components/ground.tscn")
const OBSTACLE_NUM = preload("res://scenes/game/components/obstacle_num.tscn")
const OBSTACLE_EDGE = preload("res://scenes/game/components/obstacle_edge.tscn")


var ALPHABET = {
	"a":1,"b":2,"c":3,"d":4,"e":5,"f":6,"g":7,"h":8,"i":9,"j":10,"k":11,
	"l":12,"m":13,"n":14,"o":15,"p":16,"q":17,"r":18,"s":19,"t":20,"u":21,"v":22,
	"w":23,"x":24,"y":25,"z":26
}
const ALPHABET_EDGE = {
	"E":1,"F":2,"G":3,"H":4,"I":5,"J":6,"K":7,"L":8,"M":9,"N":10,"O":11,
	"P":12,"Q":13,"R":14,"S":15,"T":16,"U":17,"V":18,"W":19,"X":20,"Y":21,"Z":22
}

@export var packed_level:PackedScene:
	set(value):
		if value != packed_level:
			print("level_data_changed by packed_level")
		packed_level = value
		#init_level()
		
@export var level_code:String:
	set(value):
		if level_code != value:
			print("level_data_changed by level_code")
		level_code = value
		#init_level_by_code()
		
var current_level_id_str:String = ""

const PAUSE_MENU = preload("res://scenes/menu/pause_menu.tscn")
const LEVEL_SELECTOR = preload("res://scenes/game/level_selector.tscn")

@onready var bg_canvas_layer: BGLayer = %BGCanvasLayer
@onready var level_container: Node2D = %LevelContainer
var progress_value = 0.0
var PROGRESS_SPEED = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BgMusic.set("parameters/switch_to_clip", "GameLevel")
	GameEvents.signal_input_scheme_changed.connect(on_signal_input_scheme_changed)
	GameEvents.signal_check_win_condition.connect(check_win_condition)
	GameEvents.signal_translation_locale_changed.connect(func():%LevelIDLabel.text = tr(current_level_id_str))
	on_signal_input_scheme_changed()
	
	var daynight_mode = GameLog.get_daynight_mode()
	%Label.text = ""
	%NextButton.hide()
	%CenterContainer.hide()
	%LevelIDLabel.text = tr(current_level_id_str)
	%CollectionLabel.text = str(GameLevelLog.get_passed_levels().size())
	
	if daynight_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")
	
	if current_level_id_str and '-' in current_level_id_str and int(current_level_id_str.split("-")[1]) <= 5:
		%HintContainer.show()
	else:
		%HintContainer.hide()
		%HintContainer.reparent(self)
	
	if GameInputControl.is_controller():
		%JoystickCursor.global_position = GameLog.get_cursor_position()
	
	init()


func init():
	#level_code = "7x7:FBBBGc0aEa3eBBaB0cBeEc0aGBBBF"
	if packed_level:
		init_level()
	elif level_code:
		init_level_by_code()


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


func init_level_by_code():
	if level_container != null and level_code != null:
		var grid = level_code.split(":")[0]
		var cells = level_code.split(":")[1]
		var width = int(grid.split("x")[0])
		var height = int(grid.split("x")[1])
		
		var level_root = LEVEL_ROOT.instantiate()
		var offset = Vector2(64,64)
		level_container.add_child(level_root)
		level_container
		var cell_idx = 0
		for i in cells:
			match i:
				"B":
					var child = OBSTACLE_NUM.instantiate() as ObstacleNum
					#level_root.call_deferred("add_child", child)
					level_root.add_child(child)
					child.hint_num = 5
					child.cell_id = Vector2i(int(cell_idx%width), int(cell_idx/width))
					child.position = Vector2(child.cell_id.x*128, child.cell_id.y*128) + offset
					cell_idx += 1
				"0","1","2","3","4":
					var child = OBSTACLE_NUM.instantiate() as ObstacleNum
					#level_root.call_deferred("add_child", child)
					level_root.add_child(child)
					child.hint_num = int(i)
					child.cell_id = Vector2i(int(cell_idx%width), int(cell_idx/width))
					child.position = Vector2(child.cell_id.x*128, child.cell_id.y*128) + offset
					cell_idx += 1
				_:
					if i in ALPHABET.keys():
						for j in range(ALPHABET[i]):
							var child = GROUND.instantiate() as Ground
							level_root.add_child(child)
							child.cell_id = Vector2i(int(cell_idx%width), int(cell_idx/width))
							child.position = Vector2(child.cell_id.x*128, child.cell_id.y*128) + offset
							cell_idx += 1
					elif i in ALPHABET_EDGE.keys():
						for j in range(ALPHABET_EDGE[i]):
							var child = OBSTACLE_EDGE.instantiate() as ObstacleEdge
							level_root.add_child(child)
							child.cell_id = Vector2i(int(cell_idx%width), int(cell_idx/width))
							child.position = Vector2(child.cell_id.x*128, child.cell_id.y*128) + offset
							cell_idx += 1
					else:
						push_error("invalid level code")
		
		var size = await level_root.adjust_position_scale()
		print("PlaceholdRect.custom_minimum_size", size)
		%PlaceholdRect.custom_minimum_size = size
		for child in level_root.get_children():
			child.set("interactable", true)
	
		%ProgressBar.custom_minimum_size.x = size.x
		%CenterContainer.show()


func _process(delta: float) -> void:
	var temp_v = lerp(%ProgressBar.value, progress_value, PROGRESS_SPEED * delta)
	temp_v = snappedf(temp_v, 0.01)
	%ProgressBar.value = temp_v
	#print(PROGRESS_SPEED * delta, " ",  %ProgressBar.value, "->", progress_value, ", ", temp_v)
	
	#Get input direction and handle movement
	var mouse_sens = 1000
	var direction: Vector2
	direction.x = Input.get_action_strength("cursor_right") - Input.get_action_strength("cursor_left")
	direction.y = Input.get_action_strength("cursor_down") - Input.get_action_strength("cursor_up")
	#print("direction", direction)
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	var movement = mouse_sens * direction * delta
	if(movement):
		simu_mouse_move(movement)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if %JoystickCursor:
			%JoystickCursor.global_position = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("next_level"):
		GameEvents.signal_level_advance.emit()


func simu_mouse_move(movement):
	#%JoystickCursor.show()
	if %JoystickCursor:
		%JoystickCursor.global_position = Vector2(
			clamp(%JoystickCursor.global_position.x + movement.x, 0., get_viewport_rect().size.x),
			clamp(%JoystickCursor.global_position.y + movement.y, 0., get_viewport_rect().size.y)
		)
		get_viewport().warp_mouse(%JoystickCursor.global_position)


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
			#print("check_win_condition", i, is_win)
	
	print("is_all_lighted: ", is_all_lighted)
	%RuleLabel4.add_theme_color_override("font_color", Color("808080"))
	for i in get_tree().get_nodes_in_group("obstacle_num"):
		(i as ObstacleNum).stop_notify()
		if not (i as ObstacleNum).is_satisfied:
			is_win = false
			if is_all_lighted:
				i.get_parent().move_child(i, i.get_parent().get_child_count(-1))
				(i as ObstacleNum).notify()
				%RuleLabel4.add_theme_color_override("font_color", Color("06a4eb"))
			#print("check_win_condition", i, is_win)
	
	%RuleLabel3.add_theme_color_override("font_color", Color("808080"))
	for i in get_tree().get_nodes_in_group("akari"):
		(i as Akari).stop_notify()
		if not (i as Akari).is_satisfied:
			is_win = false
			if is_all_lighted:
				#i.get_parent().move_child(i, i.get_parent().get_child_count(-1))
				(i as Akari).notify()
				%RuleLabel3.add_theme_color_override("font_color", Color("06a4eb"))
				
			#print("check_win_condition", i, is_win)
	
	# progress
	progress_value = (1 - (unlighted_cells_count / cells_count)) * 100
	
	print("Level Win: ", is_win)
	if is_win:
		%Label.text = "Solved"
		%NextButton.show()
		%NextButtonPlaceHold.hide()
		SfxManager.play_level_clear()
		if GameInputControl.is_controller():
			%NextButton.focus_mode = Control.FocusMode.FOCUS_ALL
			%NextButton.grab_focus()
	else:
		%Label.text = ""
		%NextButton.hide()
		%NextButtonPlaceHold.show()


func _on_reset_button_pressed() -> void:
	GameEvents.signal_level_reset.emit()


func _on_next_button_pressed() -> void:
	
	GameLog.set_cursor_position(%JoystickCursor.global_position)
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
	get_tree().current_scene.call_deferred("add_child", LEVEL_SELECTOR.instantiate())


func _on_main_button_pressed() -> void:
	#SceneLoader.load_scene("res://scenes/menu/main_menu.tscn")
	if '-' in current_level_id_str:
		SceneLoader.load_scene("res://scenes/game/game_ui/play_save_slots.tscn")
	else:
		#SceneLoader.load_scene("res://scenes/game/game_ui_infinite.tscn")
		SceneLoader.reload_current_scene()
		


func _on_help_button_pressed() -> void:
	#%HintContainer.visible = not %HintContainer.visible
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if %HintContainer.visible:
		var from_y = get_viewport_rect().size.y - %HintContainer.size.y
		var to_y = get_viewport_rect().size.y
		tween.tween_property(%HintContainer, "position:y", to_y, 0.2).from(from_y)
		tween.tween_callback(func():%HintContainer.visible = false)
	else:
		var from_y = get_viewport_rect().size.y
		var to_y = get_viewport_rect().size.y - %HintContainer.size.y
		tween.tween_callback(func():%HintContainer.visible = true)
		tween.tween_property(%HintContainer, "position:y", to_y, 0.2).from(from_y)
		

func on_signal_input_scheme_changed():
	if GameInputControl.is_mouse():
		%MouseHintContainer.show()
		%ControllerHintContainer.hide()
		
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()
			focus_owner.focus_mode = Control.FocusMode.FOCUS_NONE
		
	elif GameInputControl.is_controller():
		%MouseHintContainer.hide()
		%ControllerHintContainer.show()


func _on_hidden_puzzle_code_button_pressed() -> void:
	var level_root = level_container.get_child(0)
	if level_root is not LevelRoot:
		return
	var col_num = 0
	var row_num = 0
	for child in level_root.get_children():
		if child.cell_id.x > col_num:
			col_num = child.cell_id.x
		if child.cell_id.y > row_num:
			row_num = child.cell_id.y
	col_num += 1
	row_num += 1
	var puzzle_data = []
	for r in row_num:
		var row = []
		for c in col_num:
			row.append(null)
		puzzle_data.append(row) 
	
	for obj in level_root.get_children():
		var puzzle_cell = obj.to_puzzle_cell() as PuzzleCell
		puzzle_data[puzzle_cell.cell_id.x][puzzle_cell.cell_id.y] = puzzle_cell
	
	var puzzle_generator = PuzzleGenerator.new()
	var code = puzzle_generator.puzzle2code(puzzle_data)
	PuzzleUtils.print_puzzle(puzzle_data)
	print(code)
	DisplayServer.clipboard_set(code)
	
	puzzle_generator.reset_puzzle(puzzle_data)
	var solution_res = puzzle_generator.get_all_solutions(puzzle_data, true)
	var curr_solutions = solution_res[0]
	var curr_diffi_info = {}
	curr_diffi_info["leaf_count"] = solution_res[1].size()
	var branches = []
	var depth_sum = 0
	var depth_max = 0
	for i in solution_res[1]:
		var d = i.split("->").size()-1
		if d > depth_max:
			depth_max = d
		branches.append(d)
		depth_sum += d
	curr_diffi_info["max_depth"] = depth_max
	curr_diffi_info["avg_depth"] = int(depth_sum / branches.size())
	
	print("curr_diffi_info", curr_diffi_info)
