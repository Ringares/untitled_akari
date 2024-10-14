extends Node2D
class_name Editor

const OBSTACLE_EDGE = preload("res://scenes/game/components/obstacle_edge.tscn")
const GROUND = preload("res://scenes/game/components/ground.tscn")
const OBSTACLE_NUM = preload("res://scenes/game/components/obstacle_num.tscn")
const OBSTACLE_REFLECTER = preload("res://scenes/game/components/obstacle_reflecter.tscn")
const OBSTACLE_REPEATER = preload("res://scenes/game/components/obstacle_repeater.tscn")

@onready var puzzle_generator: PuzzleGenerator = $PuzzleGenerator

@onready var level_root: Node2D = %LevelRoot
@onready var insert_cursor: Sprite2D = %InsertCursor
@onready var selected_indicator: Sprite2D = %SelectedIndicator
@onready var marker_2d: Marker2D = $Marker2D

@onready var symetry_option_button: OptionButton = %SymetryOptionButton
@onready var percent_option_button: OptionButton = %PercentOptionButton
@onready var difficulty_option_button: OptionButton = %DifficultyOptionButton
@onready var seed_edit: TextEdit = %SeedEdit

var zoom = 1.0:
	set(value):
		zoom = value
		%LabelZoomScale.text = str(value)
		level_root.scale = Vector2.ONE * zoom
		insert_cursor.scale = Vector2.ONE * zoom
		selected_indicator.scale = Vector2.ONE * zoom
		GRID_SIZE = 128 * zoom
		
		
var GRID_SIZE = 128
var curr_selected_tool:PackedScene:
	set(value):
		curr_selected_tool = value
		if value != null:
			curr_edit_mode = EDIT_MODE.INSERT
		else:
			curr_edit_mode = EDIT_MODE.IDEL


var mouse_rela_pos
var mouse_cell_id:Vector2i
var just_placed_obstacle = null
var placed_data = {}
var init_grids:Vector2i

var curr_solutions = []
var curr_diffi_info = {}
var curr_solution_idx = 0

enum EDIT_MODE {
	IDEL,
	INSERT,
	ERASE,
	MODIFY,
	PLAY
}

var curr_edit_mode:EDIT_MODE = EDIT_MODE.IDEL:
	set(value):
		curr_edit_mode = value
		insert_cursor.hide()
		selected_indicator.hide()
		match value:
			EDIT_MODE.IDEL: 
				%LabelEditMode.text = "EDIT_MODE.IDEL"
				just_placed_obstacle = null
				for i in placed_data.keys():
					placed_data[i].set("interactable", false)
					%PlayButton.text = "Play"
					
			EDIT_MODE.INSERT:
				%LabelEditMode.text = "EDIT_MODE.INSERT"
				insert_cursor.show()
				
			EDIT_MODE.ERASE:
				just_placed_obstacle = null
				%LabelEditMode.text = "EDIT_MODE.ERASE"
				
			EDIT_MODE.MODIFY:
				just_placed_obstacle = null
				%LabelEditMode.text = "EDIT_MODE.MODIFY"
				selected_indicator.show()
				
			EDIT_MODE.PLAY:
				just_placed_obstacle = null
				for i in placed_data.keys():
					placed_data[i].set("interactable", true)
					%PlayButton.text = "Edit"


func _ready() -> void:
	EditorEvents.signal_element_selected.connect(_on_signal_element_selected)
	GameEvents.signal_check_win_condition.connect(check_win_condition)


func _process(delta: float) -> void:
	mouse_rela_pos = get_global_mouse_position() - level_root.global_position
	mouse_cell_id = local_to_grid(mouse_rela_pos)
	
	%LabelMousePos.text = "%v" % (mouse_rela_pos)
	%LabelCell.text = "%v" % mouse_cell_id
	
	if curr_edit_mode == EDIT_MODE.INSERT and curr_selected_tool != null:
		insert_cursor.global_position = get_global_mouse_position() 
		
	if Input.is_action_just_pressed("zoom_in"):
		zoom *= 1.2
	
	if Input.is_action_just_pressed("zoom_out"):
		zoom /= 1.2


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		curr_selected_tool = null
	
	if event.is_action_pressed("play_edit_switch"):
		if curr_edit_mode != EDIT_MODE.PLAY:
			curr_edit_mode = EDIT_MODE.PLAY
		else:
			curr_edit_mode = EDIT_MODE.IDEL
	
	if event.is_action_pressed("editor_erase"):
		curr_edit_mode = EDIT_MODE.ERASE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk"):
		if curr_edit_mode == EDIT_MODE.INSERT and curr_selected_tool != null:
			# insert mode
			var new_scene = curr_selected_tool.instantiate() as GridComponent
			if mouse_cell_id in placed_data and placed_data[mouse_cell_id] != null:
				placed_data[mouse_cell_id].queue_free()
			
			place_at_cell(new_scene, mouse_cell_id)

		elif curr_edit_mode == EDIT_MODE.ERASE:
			if mouse_cell_id in placed_data:
				placed_data[mouse_cell_id].queue_free()
				placed_data.erase(mouse_cell_id)
				
		elif curr_edit_mode in [EDIT_MODE.IDEL, EDIT_MODE.MODIFY]:
			# select mode
			curr_edit_mode = EDIT_MODE.MODIFY
			selected_indicator.global_position = to_global(grid_to_local(mouse_cell_id) + level_root.global_position)
			
	
	if event.is_action_pressed("num0"):
		set_number_obstacle_num(0)
	if event.is_action_pressed("num1"):
		set_number_obstacle_num(1)
	if event.is_action_pressed("num2"):
		set_number_obstacle_num(2)
	if event.is_action_pressed("num3"):
		set_number_obstacle_num(3)
	if event.is_action_pressed("num4"):
		set_number_obstacle_num(4)
	if event.is_action_pressed("num5"):
		set_number_obstacle_num(5)
		
	if event.is_action_pressed("rotate"):
		set_reflect_obstacle_rotate()


func set_number_obstacle_num(num:int):
	if just_placed_obstacle != null and just_placed_obstacle is ObstacleNum:
		just_placed_obstacle.hint_num = num
		
	if curr_edit_mode == EDIT_MODE.MODIFY:
		var cell_id = local_to_grid(selected_indicator.global_position - level_root.global_position)
		if cell_id in placed_data and placed_data[cell_id] is ObstacleNum:
			placed_data[cell_id].hint_num = num


func set_reflect_obstacle_rotate():
	if just_placed_obstacle != null and just_placed_obstacle is ObstacleReflecter:
		just_placed_obstacle.swicth_degree_set()
		
	if curr_edit_mode == EDIT_MODE.MODIFY:
		var cell_id = local_to_grid(selected_indicator.global_position - level_root.global_position)
		if cell_id in placed_data and placed_data[cell_id] is ObstacleReflecter:
			placed_data[cell_id].swicth_degree_set()
			

func init_board(init_grids: Vector2i):
	for cell_id in placed_data.keys():
		placed_data[cell_id].queue_free()
		placed_data.erase(cell_id)
	
	for i in init_grids.x:
		for j in init_grids.y:
			var new_scene = GROUND.instantiate() as Ground
			new_scene.is_editing = true
			place_at_cell(new_scene, Vector2i(i, j))
	
	while init_grids.x * 128 * zoom > 920 * 0.7:
		zoom /= 1.2
	while init_grids.x * 128 * zoom < 920 * 0.5:
		zoom *= 1.2


func place_at_cell(new_scene:GridComponent, place_cell_id:Vector2i):
	placed_data[place_cell_id] = new_scene
	level_root.add_child(new_scene)
	new_scene.cell_id = place_cell_id
	new_scene.set_owner(level_root)
	new_scene.global_position = grid_to_local(place_cell_id) + level_root.global_position
	new_scene.set("interactable", false)
	new_scene.name = "%s_%d_%d" % [new_scene.get_class_name(), new_scene.cell_id.x, new_scene.cell_id.y]
	new_scene.show()
	
	
	if new_scene is ObstacleNum or new_scene is ObstacleReflecter:
		just_placed_obstacle = new_scene
	else:
		just_placed_obstacle = null


func init_grids_by_puzzle_data(puzzle_data):
	for cell_id in placed_data.keys():
		placed_data[cell_id].queue_free()
		placed_data.erase(cell_id)
		
	for row in puzzle_data:
		for cell in row:
			var new_scene
			if cell.type == PuzzleCell.Type.BLANK:
				new_scene = GROUND.instantiate()
				new_scene.is_editing = true
				if cell.has_light:
					new_scene.call_deferred("left_clk")
			elif cell.type == PuzzleCell.Type.EDGE:
				new_scene = OBSTACLE_EDGE.instantiate()
			elif cell.type == PuzzleCell.Type.NUM:
				new_scene = OBSTACLE_NUM.instantiate()
				new_scene.hint_num = cell.num
			elif cell.type == PuzzleCell.Type.BLACK:
				new_scene = OBSTACLE_NUM.instantiate()
				new_scene.hint_num = new_scene.max_hint_num
			elif cell.type == PuzzleCell.Type.SPEC_REFLECTER_135:
				new_scene = OBSTACLE_REFLECTER.instantiate()
			elif cell.type == PuzzleCell.Type.SPEC_REFLECTER_45:
				new_scene = OBSTACLE_REFLECTER.instantiate()
				new_scene.swicth_degree_set()
			elif cell.type == PuzzleCell.Type.SPEC_REPEATER:
				new_scene = OBSTACLE_REPEATER.instantiate()
				
			place_at_cell(new_scene, Vector2i(cell.cell_id.y, cell.cell_id.x))
	
	while init_grids.x * 128 * zoom > 920 * 0.7:
		zoom /= 1.2
	while init_grids.x * 128 * zoom < 920 * 0.5:
		zoom *= 1.2


func local_to_grid(pos:Vector2):
	return Vector2i(round(snap(pos).x / GRID_SIZE), round(snap(pos).y / GRID_SIZE))


func snap(pos:Vector2): 
	return (pos - Vector2(GRID_SIZE/2, GRID_SIZE/2)).snapped(Vector2(GRID_SIZE, GRID_SIZE))


func grid_to_local(pos:Vector2i):
	return Vector2(pos * GRID_SIZE) + Vector2(GRID_SIZE/2, GRID_SIZE/2)


func _on_signal_element_selected(selected:PackedScene):
	curr_selected_tool = selected


func _on_save_button_pressed() -> void:
	var packed_scene = PackedScene.new()
	packed_scene.pack(%LevelRoot)
	var error = ResourceSaver.save(
		packed_scene, 
		"res://scenes/level_editor/levels/level_data_%s_%s.tscn" % [str(init_grids.x) + "_" +str(init_grids.y), UUID.v4()])
	
	if error != OK:
		push_error("An error occurred while saving the scene to disk.")
		push_error(error)
	else:
		init_board(init_grids)
	


func check_win_condition():
	var is_win = true
	for i in get_tree().get_nodes_in_group("ground"):
		if not (i as Ground).is_lighted:
			is_win = false
			break

	for i in get_tree().get_nodes_in_group("obstacle"):
		if not (i as Obstacle).is_satisfied:
			is_win = false
			break
	
	for i in get_tree().get_nodes_in_group("akari"):
		if not (i as Akari).is_satisfied:
			is_win = false
			break
	if is_win:
		%LabelWinCheck.text = "Win"
	else:
		%LabelWinCheck.text = "Not Win"


func get_puzzle_data_by_grid():
	var puzzle_data = []
	for i in init_grids.y:
		var row = []
		for j in init_grids.x:
			row.append(null)
		puzzle_data.append(row) 
		
	for key in placed_data.keys():
		var obj = placed_data[key] as GridComponent
		var puzzle_cell = obj.to_puzzle_cell() as PuzzleCell
		puzzle_data[puzzle_cell.cell_id.x][puzzle_cell.cell_id.y] = puzzle_cell
	return puzzle_data
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func _on_play_button_pressed() -> void:
	if curr_edit_mode != EDIT_MODE.PLAY:
		curr_edit_mode = EDIT_MODE.PLAY
	else:
		curr_edit_mode = EDIT_MODE.IDEL
	

func _on_load_button_pressed() -> void:
	var clip_board_content = DisplayServer.clipboard_get()
	%ConfirmationDialog.dialog_text = clip_board_content
	%ConfirmationDialog.confirmed.disconnect(init_grids_by_code)
	%ConfirmationDialog.confirmed.connect(init_grids_by_code.bind(clip_board_content), CONNECT_ONE_SHOT)
	%ConfirmationDialog.popup_centered()


func init_grids_by_code(code):
	var size = code.split(":")[0]
	var puzzle_data = puzzle_generator.generate_puzzle_by_code(code)
	curr_solutions = []
	%LabelSolutionCount.text = ""
	init_grids = Vector2i(int(size.split("x")[0]), int(size.split("x")[1]))
	init_grids_by_puzzle_data(puzzle_data)


func _on_copy_button_pressed() -> void:
	var code = puzzle_generator.puzzle2code(get_puzzle_data_by_grid())
	DisplayServer.clipboard_set(code)
	

func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
	curr_edit_mode = EDIT_MODE.IDEL

#
#func _on_expand_button_pressed() -> void:
	#var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#if %GeneratorContainer.position.x !=0:
		#tween.tween_property(%GeneratorContainer, "position:x", 0, 0.2)
	#else:
		#tween.tween_property(%GeneratorContainer, "position:x", -480, 0.2)
		

func _on_init_grid_button_pressed() -> void:
	curr_solutions = []
	%LabelSolutionCount.text = ""
	init_grids = Vector2i(int(%RowSizeEdit.text), int(%ColSizeEdit.text)) 
	init_board(init_grids)
	curr_edit_mode = EDIT_MODE.IDEL


func _on_random_wall_button_pressed() -> void:
	curr_solutions = []
	%LabelSolutionCount.text = ""
	var symetry_option = symetry_option_button.get_selected_id()
	var wall_percent_option = [0.2,0.3][percent_option_button.get_selected_id()]
	var difficulty_option = difficulty_option_button.get_selected_id()
	if seed_edit.text:
		seed(int(seed_edit.text))
	else:
		seed(Time.get_ticks_msec())
	
	init_grids = Vector2i(int(%RowSizeEdit.text), int(%ColSizeEdit.text)) 
	var wall_count_required = init_grids.x * init_grids.y * wall_percent_option
	var puzzle_data = puzzle_generator.generate_empty_puzzle_with_wall(Vector2i(init_grids.y, init_grids.x), symetry_option, wall_count_required)
	PuzzleUtils.print_puzzle(puzzle_data)
	init_grids_by_puzzle_data(puzzle_data)
	

func _on_random_light_button_pressed() -> void:
	curr_solutions = []
	%LabelSolutionCount.text = ""
	if seed_edit.text:
		seed(int(seed_edit.text))
	else:
		seed(Time.get_ticks_msec())
	var puzzle_data = get_puzzle_data_by_grid()
	puzzle_generator.restore_walls(puzzle_data)
	puzzle_generator.gen_init_lights(puzzle_data)
	#PuzzleUtils.print_puzzle(puzzle_data)
	init_grids_by_puzzle_data(puzzle_data)


func _on_set_num_button_pressed() -> void:
	var puzzle_data = get_puzzle_data_by_grid()
	#PuzzleUtils.print_puzzle(puzzle_data)
	puzzle_generator.gen_init_nums(puzzle_data)
	init_grids_by_puzzle_data(puzzle_data)
	
	
func _on_check_solution_button_pressed() -> void:
	if curr_solutions.size() == 0:
		var puzzle_data = get_puzzle_data_by_grid()
		puzzle_generator.reset_puzzle(puzzle_data)
		var solution_res = puzzle_generator.get_all_solutions(puzzle_data, true)
		curr_solutions = solution_res[0]
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
		%LabelSolutionCount.text = str(curr_solutions.size())
		print("solutions: ")
		#for s in curr_solutions:
			#PuzzleUtils.print_puzzle(s)
		if curr_solutions.size() > 0:
			curr_solution_idx = 0
			PuzzleUtils.print_puzzle(curr_solutions[curr_solution_idx])
			init_grids_by_puzzle_data(curr_solutions[curr_solution_idx])
	else:
		curr_solution_idx = (curr_solution_idx + 1) % curr_solutions.size()
		print("curr_diffi_info", curr_diffi_info)
		print("solutions: ", curr_solution_idx)
		var curr_solu = curr_solutions[curr_solution_idx]
		init_grids_by_puzzle_data(curr_solu)
		PuzzleUtils.print_puzzle(curr_solu)
		

func _on_clear_button_pressed() -> void:
	curr_solutions = []
	%LabelSolutionCount.text = ""
	var puzzle_data = get_puzzle_data_by_grid()
	puzzle_generator.reset_puzzle(puzzle_data)
	init_grids_by_puzzle_data(puzzle_data)
	print(puzzle_generator.puzzle2code(puzzle_data))


func _on_symmetry_wall_button_pressed() -> void:
	curr_solutions = []
	%LabelSolutionCount.text = ""
	if seed_edit.text:
		seed(int(seed_edit.text))
	else:
		seed(Time.get_ticks_msec())
	var puzzle_data = get_puzzle_data_by_grid()
	puzzle_generator.restore_walls(puzzle_data)
	puzzle_generator.symmetry_walls(puzzle_data, symetry_option_button.get_selected_id())
	init_grids_by_puzzle_data(puzzle_data)


func _on_random_solution_button_pressed() -> void:
	_on_random_light_button_pressed()
	await get_tree().create_timer(1).timeout
	_on_set_num_button_pressed()
	await get_tree().create_timer(1).timeout
	_on_check_solution_button_pressed()
	await get_tree().create_timer(1).timeout


func _on_polish_button_pressed() -> void:
	var puzzle_data = get_puzzle_data_by_grid()
	puzzle_generator.reset_puzzle(puzzle_data)
	puzzle_generator.polish_puzzle(puzzle_data)
	init_grids_by_puzzle_data(puzzle_data)
	curr_solutions = []
	%LabelSolutionCount.text = ""
	
	
