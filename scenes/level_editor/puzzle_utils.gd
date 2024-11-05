extends RefCounted
class_name PuzzleUtils

static func duplicate_obj_array(obj_array):
	"""
	复制数组及其中对象
	"""
	var new_obj_array = []
	for r in obj_array:
		if r is Array:
			var new_row = []
			for c in r:
				new_row.append(c.self_duplicate())
			new_obj_array.append(new_row)
		else:
			new_obj_array.append(r.self_duplicate())
		
	return new_obj_array


static func is_valid_cell(puzzle_data, tar_cell:Vector2i):
	var height = puzzle_data.size()
	var width = puzzle_data[0].size()
	if tar_cell.x < 0:
		return false
	if tar_cell.x >= height:
		return false 
	if tar_cell.y <0:
		return false
	if tar_cell.y >= width:
		return false
	return true


static func print_puzzle(level_data, comment_line = ""):
	print(comment_line)
	for row in level_data:
		var printable_str = row.map(func(i): return i.get_strcode())
		print(" ".join(printable_str))


static func puzzle2str(puzzle_data):
	var res = ""
	for row in puzzle_data:
		res += "".join(row.map(func(i): return i.get_strcode()))
	return res
	

static func get_placable_neighbours(puzzle_data, curr_cell_idx:Vector2i):
	var placable_neighbours = []
	for dir in [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]:
		var tar_cell = curr_cell_idx + dir
		if PuzzleUtils.is_valid_cell(puzzle_data, tar_cell) and not puzzle_data[tar_cell.x][tar_cell.y].is_implacable and not puzzle_data[tar_cell.x][tar_cell.y].has_light:
			placable_neighbours.append(puzzle_data[tar_cell.x][tar_cell.y])
	return placable_neighbours


static func check_is_solved(puzzle_data):
	for row in puzzle_data:
		for cell in row:
			cell = cell as PuzzleCell
			if cell.type == PuzzleCell.Type.BLANK:
				if cell.is_lit == false:
					return false
			if cell.type == PuzzleCell.Type.NUM:
				if PuzzleUtils.get_light_neighbours_count(puzzle_data, cell.cell_id) != cell.num:
					return false
	return true


static func check_invalid_num(puzzle_data):
	for row in puzzle_data:
		for cell in row:
			if cell.type == PuzzleCell.Type.NUM:
				var placable_neighbours = get_placable_neighbours(puzzle_data, cell.cell_id)
				var placed_light = get_light_neighbours_count(puzzle_data, cell.cell_id)
				if placable_neighbours.size() + placed_light < cell.num:
					return true
	return false


static func check_invalid_blank(puzzle_data):
	for row in puzzle_data:
		for cell in row:
			if cell.type == PuzzleCell.Type.BLANK and not cell.is_lit and not cell.has_light:
				var candidate_to_light_cell = PuzzleUtils.get_candidate_to_light_cell(puzzle_data, cell.cell_id)
				if candidate_to_light_cell.size() == 0:
					return true
	return false


static func get_candidate_priority(puzzle_data, curr_cell_idx:Vector2i):
	var num_sum = 0
	var is_nearby_num_count = 0
	for dir in [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]:
		var tar_cell = curr_cell_idx + dir
		if PuzzleUtils.is_valid_cell(puzzle_data, tar_cell) and puzzle_data[tar_cell.x][tar_cell.y].type == PuzzleCell.Type.NUM:
			is_nearby_num_count += 1
			num_sum += get_placable_neighbours(puzzle_data, tar_cell).size() - puzzle_data[tar_cell.x][tar_cell.y].num
	if is_nearby_num_count == 0:
		return 100
	else:
		return num_sum / is_nearby_num_count


static func get_light_neighbours_count(puzzle_data, curr_cell_idx:Vector2i):
	"""
	周围light数
	"""
	var num_sum = 0
	for dir in [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]:
		var tar_cell = curr_cell_idx + dir
		if PuzzleUtils.is_valid_cell(puzzle_data, tar_cell):# and puzzle_data[curr_cell_idx.x][curr_cell_idx.y].type == PuzzleCell.Type.NUM:
			num_sum += 1 if puzzle_data[tar_cell.x][tar_cell.y].has_light else 0
	return num_sum
	

static func get_conner_cells(curr_cell_idx:Vector2i, cells:Array):
	"""
	获取对应的斜角
	"""
	var conner_cells = []
	for i in cells:
		for j in cells:
			if i != j and i.distance_to(j) < 2:
				var conner_cell = i-curr_cell_idx+j
				if conner_cell not in conner_cells:
					conner_cells.append(conner_cell)
	return conner_cells


static func get_candidate_to_light_cell(puzzle_data, curr_cell_idx:Vector2i):
	"""
	计算点亮当前格的所有可能其它位置
	# FixME
	"""
	var candidates_to_light = []
	var curr_cell = puzzle_data[curr_cell_idx.x][curr_cell_idx.y]
	if not curr_cell.is_lit and not curr_cell.is_implacable:
		candidates_to_light.append(curr_cell)
	for dir in [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]:
		get_candidate_to_light_cell_on_dir(puzzle_data, curr_cell_idx, dir, candidates_to_light)
		#var temp_cell_id = curr_cell_idx
		#while true:
			#temp_cell_id = temp_cell_id + dir
			#if not PuzzleUtils.is_valid_cell(puzzle_data, temp_cell_id): # 到边界，停止
				#break
			#var temp_cell = puzzle_data[temp_cell_id.x][temp_cell_id.y]
			#if temp_cell.type != PuzzleCell.Type.BLANK:  # 到阻挡，停止
				#break
			#if not temp_cell.is_lit and not temp_cell.is_implacable:
				#candidates_to_light.append(temp_cell)
	return candidates_to_light


static func get_candidate_to_light_cell_on_dir(puzzle_data, curr_cell_idx:Vector2i, dir:Vector2i, candidates_to_light:Array):
	"""
	dir: reverse-light dir
	"""
	var temp_cell_id = curr_cell_idx
	while true:
		temp_cell_id = temp_cell_id + dir
		if not PuzzleUtils.is_valid_cell(puzzle_data, temp_cell_id): # 到边界，停止
			break
		if puzzle_data[temp_cell_id.x][temp_cell_id.y].type in [PuzzleCell.Type.BLACK, PuzzleCell.Type.NUM, PuzzleCell.Type.EDGE]:  # 到阻挡，停止
			break
		if puzzle_data[temp_cell_id.x][temp_cell_id.y].type == PuzzleCell.Type.SPEC_REFLECTER_135:
			var reflect_dir = ReflectUtils.get_reflect_dir(ReflectUtils.DEGREE_SET.DEG_135, -dir)
			get_candidate_to_light_cell_on_dir(puzzle_data, temp_cell_id, reflect_dir, candidates_to_light)
			break
		if puzzle_data[temp_cell_id.x][temp_cell_id.y].type == PuzzleCell.Type.SPEC_REFLECTER_45:
			var reflect_dir = ReflectUtils.get_reflect_dir(ReflectUtils.DEGREE_SET.DEG_45, -dir)
			get_candidate_to_light_cell_on_dir(puzzle_data, temp_cell_id, reflect_dir, candidates_to_light)
			break
		if puzzle_data[temp_cell_id.x][temp_cell_id.y].type == PuzzleCell.Type.SPEC_REPEATER:
			var all_dir = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
			all_dir.erase(-dir)
			for repeat_dir in all_dir:
				get_candidate_to_light_cell_on_dir(puzzle_data, temp_cell_id, repeat_dir, candidates_to_light)
			break
		if puzzle_data[temp_cell_id.x][temp_cell_id.y].type == PuzzleCell.Type.SPEC_WH:
			var linked_cell_id = puzzle_data[temp_cell_id.x][temp_cell_id.y].linked_cell_id
			get_candidate_to_light_cell_on_dir(puzzle_data, linked_cell_id, dir, candidates_to_light)
			break
			
		if not puzzle_data[temp_cell_id.x][temp_cell_id.y].is_lit and not puzzle_data[temp_cell_id.x][temp_cell_id.y].is_implacable:
			candidates_to_light.append(puzzle_data[temp_cell_id.x][temp_cell_id.y])



static func mark_implacable(puzzle_data, curr_cell_idx:Vector2i, offset:Vector2i=Vector2i.ZERO):
	var has_new_mark = false
	var tar_cell = curr_cell_idx + offset
	if not PuzzleUtils.is_valid_cell(puzzle_data, tar_cell):
		return has_new_mark
	
	if not puzzle_data[tar_cell.x][tar_cell.y].is_implacable:
		puzzle_data[tar_cell.x][tar_cell.y].is_implacable = true
		has_new_mark = true
		#print("set tar_cell ", tar_cell, " is_implacable=true")
	return has_new_mark


static func place_light(puzzle_data, curr_cell_idx:Vector2i, offset:Vector2i=Vector2i.ZERO):
	"""
	curr_cell_idx [row_id,col_id]
	"""
	var has_new_mark = false  # 检查是否有新标记的
	var tar_cell = curr_cell_idx + offset
	if not PuzzleUtils.is_valid_cell(puzzle_data, tar_cell):
		return has_new_mark  # 没有成功放灯的话，不会有新的标记
	if puzzle_data[tar_cell.x][tar_cell.y].type != PuzzleCell.Type.BLANK:
		return has_new_mark
	
	if not puzzle_data[tar_cell.x][tar_cell.y].is_lit:
		puzzle_data[tar_cell.x][tar_cell.y].has_light = true
		puzzle_data[tar_cell.x][tar_cell.y].is_lit = true
		
		# 成功放灯，开始传递并检查
		for dir in [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]:
			has_new_mark = pass_light(puzzle_data, tar_cell, dir) or has_new_mark
	return has_new_mark
	
	
static func pass_light(puzzle_data, curr_cell_idx, dir:Vector2i):
	var has_new_mark = false
	var temp_cell = curr_cell_idx
	while true:
		temp_cell = temp_cell + dir
		if not PuzzleUtils.is_valid_cell(puzzle_data, temp_cell): # 到边界，停止
			break
		if puzzle_data[temp_cell.x][temp_cell.y].type in [PuzzleCell.Type.BLACK, PuzzleCell.Type.NUM, PuzzleCell.Type.EDGE]:  # 到阻挡，停止
			break
		if puzzle_data[temp_cell.x][temp_cell.y].type == PuzzleCell.Type.SPEC_REFLECTER_135:
			var reflect_dir = ReflectUtils.get_reflect_dir(ReflectUtils.DEGREE_SET.DEG_135, -dir)
			has_new_mark = pass_light(puzzle_data, temp_cell, reflect_dir) or has_new_mark
			break
		if puzzle_data[temp_cell.x][temp_cell.y].type == PuzzleCell.Type.SPEC_REFLECTER_45:
			var reflect_dir = ReflectUtils.get_reflect_dir(ReflectUtils.DEGREE_SET.DEG_45, -dir)
			has_new_mark = pass_light(puzzle_data, temp_cell, reflect_dir) or has_new_mark
			break
		if puzzle_data[temp_cell.x][temp_cell.y].type == PuzzleCell.Type.SPEC_REPEATER:
			var all_dir = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
			all_dir.erase(-dir)
			for repeat_dir in all_dir:
				has_new_mark = pass_light(puzzle_data, temp_cell, repeat_dir) or has_new_mark
			break
		if puzzle_data[temp_cell.x][temp_cell.y].type == PuzzleCell.Type.SPEC_WH:
			var linked_cell_id = puzzle_data[temp_cell.x][temp_cell.y].linked_cell_id
			has_new_mark = pass_light(puzzle_data, linked_cell_id, dir) or has_new_mark
			break
		puzzle_data[temp_cell.x][temp_cell.y].is_lit = true
		has_new_mark = mark_implacable(puzzle_data, temp_cell) or has_new_mark
	
	return has_new_mark
