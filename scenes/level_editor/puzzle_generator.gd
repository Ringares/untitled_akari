extends Node
class_name PuzzleGenerator

#@export var width:int
#@export var height:int

const ALPHABET = {
	"a":1,"b":2,"c":3,"d":4,"e":5,"f":6,"g":7,"h":8,"i":9,"j":10,"k":11,
	"l":12,"m":13,"n":14,"o":15,"p":16,"q":17,"r":18,"s":19,"t":20,"u":21,"v":22,
	"w":23,"x":24,"y":25,"z":26
}
const ALPHABET_LIST = [
	"", "a","b","c","d","e","f","g","h","i","j","k",
	"l","m","n","o","p","q","r","s","t","u","v",
	"w","x","y","z"
]
const ALPHABET_EDGE = {
	"E":1,"F":2,"G":3,"H":4,"I":5,"J":6,"K":7,"L":8,"M":9,"N":10,"O":11,
	"P":12,"Q":13,"R":14,"S":15,"T":16,
	#"U":17,"V":18,"W":19,"X":20,"Y":21,"Z":22
}
const ALPHABET_EDGE_LIST = [
	"","E","F","G","H","I","J","K","L","M","N","O",
	"P","Q","R","S","T",
	#"U","V","W","X","Y","Z"
]

const SINGLETIME_GEN_MSEC = 20000


enum SymmetryType {
	TwoWayMirror=0,
	TwoWayRotational=1,
	FourWayMirror=2,
	FourWayRotational=3,
}


func generate_new_puzzle(
	size:Vector2i, 
	symmetry_type:SymmetryType, 
	wall_percent:float, 
	edge_list=[],
	rand_seed=Time.get_ticks_msec()
	):
	"""
	return 
		final_puzzle_data: [[], ...]
		puzzle_diffi_info: {}
	"""
	if rand_seed:
		seed(int(rand_seed))
		
	var wall_count_required = size.x * size.y * wall_percent
	var is_valid = false
	var puzzle_data
	var gen_time_cond = [Time.get_ticks_msec(), SINGLETIME_GEN_MSEC]
	while not is_valid:
		# Step1
		# 创建空网格+blackblock
		var original_puzzle_data = generate_empty_puzzle_with_wall(size, symmetry_type, wall_count_required, edge_list)
		#PuzzleUtils.print_puzzle(original_puzzle_data)
		
		# Step2+3
		var init_try_count = 0
		var solution_count = 0
		
		while solution_count != 1 and init_try_count < 5:
			if BgPuzzleGenerator.is_terminated():
				return null
			
			puzzle_data = PuzzleUtils.duplicate_obj_array(original_puzzle_data)
			# 放置初始解+计算数字
			gen_init_solution_and_nums(puzzle_data)
			# 清空解 + 打印
			reset_puzzle(puzzle_data)
			#PuzzleUtils.print_puzzle(puzzle_data)
			
			# 计算解的数量
			# 尝试 5 次生成初解
			print('	try solving ', init_try_count)
			solution_count = get_solution_count(puzzle_data, gen_time_cond)
			print('	try solving done')
			init_try_count += 1
			
		
		if gen_time_cond != null:
			var start_msec = gen_time_cond[0]
			var threshold = gen_time_cond[1]
			if Time.get_ticks_msec() - start_msec > threshold:
				print("time's up")
				return null
			
		is_valid = solution_count == 1
		wall_count_required += 1
	
	## Step5 打磨调整 puzzle, 尝试去掉多余的条件
	print('	start polishing')
	polish_puzzle(puzzle_data, gen_time_cond)
	if BgPuzzleGenerator.is_terminated():
		return null
	reset_puzzle(puzzle_data)
	##var puzzle_data2 = generate_puzzle_by_code(puzzle2code(puzzle_data))
	## check puzzle_data diff
	#for i in range(puzzle_data.size()):
		#for j in range(puzzle_data[0].size()):
			#print(str(puzzle_data[i][j]) == str(puzzle_data2[i][j]), puzzle_data[i][j], " vs ", puzzle_data2[i][j])
	
	#print(puzzle2code(puzzle_data))
	var solution_res = get_all_solutions(puzzle_data, false)
	var solutions = solution_res[0]
	var solution_logs = solution_res[1]
	if solutions == [] or solution_logs == []:
		return null
	var puzzle_diffi_info = cal_puzzle_diffi(solution_logs)
	
	print("\n\nfinal puzzle")
	print("gen_time: ", Time.get_ticks_msec() - gen_time_cond[0])
	print("solutions count: ", solutions.size())
	print(solution_logs)
	print(puzzle_diffi_info)
	PuzzleUtils.print_puzzle(puzzle_data)
	#PuzzleUtils.print_puzzle(solutions[0])
	print(puzzle2code(puzzle_data))
	
	return [puzzle_data, puzzle_diffi_info]
	

func generate_empty_puzzle_with_wall(size:Vector2i, symmetry_type:SymmetryType, wall_count_required:float, edge_list=[]):
	# 初始化分布权重
	var height = int(size.x)
	var width = int(size.y)
	var puzzle_data = []
	for i in height:
		var row = []
		var cell = null
		for j in width:
			if Vector2i(i, j) in edge_list:
				cell = PuzzleCell.inst(Vector2i(i, j), PuzzleCell.Type.EDGE)
				cell.heuristic_value = 0
			else:
				cell = PuzzleCell.inst(Vector2i(i, j), PuzzleCell.Type.BLANK)
				cell.heuristic_value = 4
			row.append(cell)
		puzzle_data.append(row)
		
	# 初始化加权表
	wall_count_required = randi_range(ceili(wall_count_required), floori(wall_count_required))
	var wall_count = 0
	var w_table = WeightTable.new()
	for i in height:
		for j in width:
			var cell = puzzle_data[i][j] as PuzzleCell
			var heuristic_value = 1
			w_table.add_item(cell.cell_id, cell.heuristic_value)
	
	while wall_count < wall_count_required:
		var new_wall_ids = []
		var new_wall_id = w_table.rand_pick()
		new_wall_ids.append(new_wall_id)
		new_wall_ids.append_array(cal_symmetry_pos(new_wall_id, symmetry_type, width, height))
		wall_count += new_wall_ids.size()
		
		# 调整 w_table
		for wall_id in new_wall_ids:
			for row in puzzle_data:
				for cell in row:
					if cell.type == PuzzleCell.Type.BLANK:
						if cell.cell_id == wall_id:
							cell.type = PuzzleCell.Type.BLACK
							w_table.add_item(cell.cell_id, 0, true)
						else:
							var distance = abs(cell.cell_id.x - wall_id.x) + abs(cell.cell_id.y - wall_id.y)
							w_table.add_item(cell.cell_id, distance)
		
	return puzzle_data


func cal_symmetry_pos(new_wall_id, symmetry_type, w, h):
	var symmetry_pos_list = []
	match symmetry_type:
		SymmetryType.TwoWayMirror:
			var temp_pos = Vector2i(h-1-new_wall_id.x, new_wall_id.y)
			if temp_pos != new_wall_id:
				symmetry_pos_list.append(temp_pos)
		SymmetryType.TwoWayRotational: 
			var temp_pos = Vector2i(h-1-new_wall_id.x, w-1-new_wall_id.y)
			if temp_pos != new_wall_id:
				symmetry_pos_list.append(temp_pos)
		SymmetryType.FourWayMirror: 
			for temp_pos in [
				Vector2i(h-1-new_wall_id.x, new_wall_id.y),
				Vector2i(new_wall_id.x, w-1-new_wall_id.y),
				Vector2i(h-1-new_wall_id.x, w-1-new_wall_id.y),
				]:
				if temp_pos != new_wall_id:
					symmetry_pos_list.append(temp_pos)
			
		SymmetryType.FourWayRotational: 
			for temp_pos in [
				Vector2i(h-1-new_wall_id.x, w-1-new_wall_id.y),
				Vector2i(new_wall_id.y, w-1-new_wall_id.x,),
				Vector2i(h-1-new_wall_id.y, new_wall_id.x),
				]:
				if temp_pos != new_wall_id:
					symmetry_pos_list.append(temp_pos)
	return symmetry_pos_list
	

func adjust_puzzle_wall(puzzle_data, symmetry_type:SymmetryType, wall_percent:float):
	pass
	

func polish_puzzle(puzzle_data, gen_time_cond=null):
	for row in puzzle_data:
		for cell in row:
			if cell.type == PuzzleCell.Type.NUM:
				var original_type = cell.type
				var original_num = cell.num
				cell.type = PuzzleCell.Type.BLACK
				cell.num = -1
				
				if get_solution_count(puzzle_data, gen_time_cond) != 1:
					cell.type = original_type
					cell.num = original_num
				if gen_time_cond != null:
					var start_msec = gen_time_cond[0]
					var threshold = gen_time_cond[1]
					if Time.get_ticks_msec() - start_msec > threshold:
						cell.type = original_type
						cell.num = original_num


func gen_init_solution_and_nums(puzzle_data):
	# Step2: generate init solution without num constrains
	gen_init_lights(puzzle_data)
	
	# Step3: init nums
	gen_init_nums(puzzle_data)


func restore_walls(puzzle_data):
	for row in puzzle_data:
		for cell in row:
			if cell.type == PuzzleCell.Type.NUM:
				cell.type = PuzzleCell.Type.BLACK
				cell.num = -1
			elif cell.type == PuzzleCell.Type.BLANK:
				cell.has_light = false
				cell.is_lit = false
	
	
func symmetry_walls(puzzle_data, symmetry_type):
	if puzzle_data == []:
		return
	var width = puzzle_data[0].size()
	var height = puzzle_data.size()
	for row in puzzle_data:
		for cell in row:
			if cell.type == PuzzleCell.Type.BLACK:
				for symmetry_pos in cal_symmetry_pos(cell.cell_id, symmetry_type, width, height):
					puzzle_data[symmetry_pos.x][symmetry_pos.y].type = PuzzleCell.Type.BLACK
				


func gen_init_lights(puzzle_data):
	#seed(Time.get_ticks_msec())
	while not PuzzleUtils.check_is_solved(puzzle_data):
		# 先进性初步求解
		var trivial_result = PuzzleSolver.trivial_solver(puzzle_data)
		var has_new_mark = trivial_result[0]
		while has_new_mark:
			trivial_result = PuzzleSolver.trivial_solver(puzzle_data)
			has_new_mark = trivial_result[0]
			
		# 取所有剩下的候选位置
		# 排序：贴着数字约束的候选位置优先级高， 数字和越大约优先
		var candidates = trivial_result[1]
		
		var candi_size = candidates.size()
		var new_light = candidates.pop_at(randi_range(0,candi_size-1))
		if new_light:
			print_verbose("place light at ", new_light.cell_id)
			PuzzleUtils.place_light(puzzle_data, new_light.cell_id)
		else:
			break


func gen_init_nums(puzzle_data):
	var height = puzzle_data.size()
	var width = puzzle_data[0].size()
	for i in height:
		for j in width:
			var curr_cell = puzzle_data[i][j] as PuzzleCell
			if curr_cell.type == PuzzleCell.Type.BLACK:
				var count = PuzzleUtils.get_light_neighbours_count(puzzle_data, curr_cell.cell_id)
				curr_cell.num = count
				curr_cell.type = PuzzleCell.Type.NUM


func get_solution_count(puzzle_data, gen_time_cond=null):
	return get_all_solutions(puzzle_data, false, gen_time_cond)[0].size()


func get_all_solutions(puzzle_data, verbose=false, gen_time_cond=null):
	var solutions = []
	var solution_logs = []
	PuzzleSolver.backtrack_solver2(PuzzleUtils.duplicate_obj_array(puzzle_data), solutions, solution_logs, verbose, gen_time_cond)
	if verbose:
		print("solutions count: ", solutions.size())
		print(solution_logs)
	return [solutions, solution_logs]
	

func generate_puzzle_by_code(level_code:String):
	var grid = level_code.split(":")[0]
	var cells = level_code.split(":")[1]
	var width = int(grid.split("x")[0])
	var height = int(grid.split("x")[1])
	var puzzle_data = []
	for i in height:
		var row = []
		for j in width:
			row.append(null)
		puzzle_data.append(row)
		
	var row_id
	var col_id
	
	var cell_idx = 0
	var wh_list = []
	for i in cells:
		match i:
			"B":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.BLACK)
				cell_idx += 1
			
			"W":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.SPEC_WH)
				cell_idx += 1
				wh_list.append(puzzle_data[row_id][col_id])
				
			"X":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.SPEC_REPEATER)
				cell_idx += 1
			
			"Y":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.SPEC_REFLECTER_135)
				cell_idx += 1
			
			"Z":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.SPEC_REFLECTER_45)
				cell_idx += 1
				
			"0","1","2","3","4":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.NUM, int(i))
				cell_idx += 1
			_:
				if i in ALPHABET.keys():
					for j in range(ALPHABET[i]):
						row_id = int(cell_idx/width)
						col_id = int(cell_idx%width)
						puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.BLANK)
						cell_idx += 1
				elif i in ALPHABET_EDGE.keys():
					for j in range(ALPHABET_EDGE[i]):
						row_id = int(cell_idx/width)
						col_id = int(cell_idx%width)
						puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.EDGE)
						cell_idx += 1
				else:
					push_error("invalid level code")
	
	assert(wh_list.size() == 0 or wh_list.size() == 2)
	if wh_list.size() == 2:
		wh_list[0].linked_cell_id = wh_list[1].cell_id
		wh_list[1].linked_cell_id = wh_list[2].cell_id
	
	return puzzle_data


static func puzzle2code(puzzle_data):
	"""
	转化为 puzzle code
	e.g. 7x7:EBs2...
	"""
	var res = ""
	var code = []
	var h = puzzle_data.size()
	var w = puzzle_data[0].size()
	for row in puzzle_data:
		for cell in row:
			match cell.type:
				PuzzleCell.Type.EDGE: 
					if code.size() == 0:
						code.append("E")
					elif code[-1] in ALPHABET_EDGE:
						if code[-1] == ALPHABET_EDGE_LIST[-1]:
							code.append("E")
						else:
							var last_code = code.pop_back()
							code.append(ALPHABET_EDGE_LIST[ALPHABET_EDGE[last_code]+1])
					else:
						code.append("E")
				
				PuzzleCell.Type.BLANK:
					if code.size() == 0:
						code.append("a")
					elif code[-1] in ALPHABET:
						if code[-1] == ALPHABET_LIST[-1]:
							code.append("a")
						else:
							var last_code = code.pop_back()
							code.append(ALPHABET_LIST[ALPHABET[last_code]+1])
					else:
						code.append("a")
						
					
				PuzzleCell.Type.BLACK: code.append("B")
				PuzzleCell.Type.NUM: code.append(str(cell.num))
				PuzzleCell.Type.SPEC_WH: code.append("W")
				PuzzleCell.Type.SPEC_REPEATER: code.append("X")
				PuzzleCell.Type.SPEC_REFLECTER_135: code.append("Y")
				PuzzleCell.Type.SPEC_REFLECTER_45: code.append("Z")
			
	res = str(w) + "x" + str(h) + ":"+ "".join(code)
	return res


static func reset_puzzle(puzzle_data):
	"""
	重置puzzle数据，取消 implacable, light 标记
	"""
	for row in puzzle_data:
		for cell in row:
			cell.reset()
	

static func cal_puzzle_diffi(solution_log):
	var curr_diffi_info = {
		"leaf_count": solution_log.size()
	}
	var branches = []
	var depth_sum = 0
	var depth_max = 0
	for i in solution_log:
		var d = i.split("->").size()-1
		if d > depth_max:
			depth_max = d
		branches.append(d)
		depth_sum += d
	curr_diffi_info["max_depth"] = depth_max
	curr_diffi_info["avg_depth"] = int(depth_sum / branches.size())
	return curr_diffi_info
