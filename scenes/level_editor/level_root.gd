extends Node2D
class_name LevelRoot

@export var GRID_SIZE = 128

func _ready() -> void:
	#var a = get_parent() is Window
	#print(get_parent())
	if get_parent() is Window:
		adjust_position_scale()
		
		var btn = Button.new()
		btn.text = "???"
		btn.global_position.x -= 100
		btn.pressed.connect(_on_button_pressed)
		add_child(btn)

func adjust_position_scale() -> Vector2:
	self.scale = Vector2.ONE
	var furthest_x_pos = 0.
	var furthest_y_pos = 0.
	var furthest_x_cell = 0
	var furthest_y_cell = 0
	for i in get_children():
		#print(i.global_position)
		if i.global_position.x > furthest_x_pos:
			furthest_x_pos = i.global_position.x
			furthest_x_cell = i.cell_id.x
		if i.global_position.y > furthest_y_pos:
			furthest_y_pos = i.global_position.y
			furthest_y_cell = i.cell_id.y
	
	var board_rect = Vector2(
		furthest_x_pos + GRID_SIZE / 2.0 - global_position.x, 
		furthest_y_pos + GRID_SIZE / 2.0 - global_position.y
	)
	
	var scale_x = (get_viewport_rect().size.x * 2 / 3) / board_rect.x
	var scale_y = (get_viewport_rect().size.y * 2 / 3) / board_rect.y
	
	var final_scale = clamp(min(scale_x, scale_y), 0.1, 1.0)
	#print(final_scale)
	self.scale = Vector2(final_scale, final_scale)
	self.global_position = Vector2(
		get_viewport_rect().size.x / 2. - board_rect.x * final_scale / 2.,
		get_viewport_rect().size.y / 2. - board_rect.y * final_scale / 2.
	)
	
	var max_dist = 0
	for i in get_children():
		if i is not GridComponent:
			continue
		var dist = abs(furthest_x_cell / 2.0 - i.cell_id.x) + abs(furthest_y_cell / 2.0 - i.cell_id.y) 
		max_dist = max(max_dist, dist)
		i.show_up(dist)
		
	for delay in max_dist:
		await get_tree().create_timer(0.08).timeout
		SfxManager.play_light_up()
	
	return Vector2((furthest_x_cell + 1) * GRID_SIZE * final_scale, (furthest_y_cell + 1) * GRID_SIZE * final_scale)
	
	


func _on_button_pressed() -> void:
	var col_num = 0
	var row_num = 0
	for child in self.get_children():
		if child is not GridComponent:
			continue 
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
	
	for obj in self.get_children():
		if obj is not GridComponent:
			continue
		var puzzle_cell = obj.to_puzzle_cell() as PuzzleCell
		puzzle_data[puzzle_cell.cell_id.x][puzzle_cell.cell_id.y] = puzzle_cell
	
	var code = PuzzleGenerator.puzzle2code(puzzle_data)
	PuzzleUtils.print_puzzle(puzzle_data)
	print(code)
	DisplayServer.clipboard_set(code)
	
	var puzzle_generator = PuzzleGenerator.new()
	puzzle_generator.reset_puzzle(puzzle_data)
	var solution_res = puzzle_generator.get_all_solutions(puzzle_data, false)
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
	await get_tree().create_timer(2).timeout
	DisplayServer.clipboard_set(str(curr_diffi_info))
	get_tree().quit()
