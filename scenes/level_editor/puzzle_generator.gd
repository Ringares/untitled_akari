extends Node
class_name PuzzleGenerator

@export var width:int
@export var height:int

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


enum SymmetryType {
	TwoWayMirror=0,
	TwoWayRotational=1,
	FourWayMirror=2,
	FourWayRotational=3,
}

func _ready() -> void:
	#var puzzle_code = "5x5:a3g1bBb0gBa"
	#var puzzle_code = "5x7:f0B0dBb0f2b10Bf"
	#var puzzle_code = "7x7:a1a0d1cB2g1e1g11c2dBaBa"
	#var puzzle_code = "7x7:bBb2aBh2a1a1gBa0a1h2a2bBb"
	#var puzzle_code = "7x7:e0a2aBa2cBcBi2cBc1a1aBa1e"
	#var puzzle_code = "7x7:a2fBbB1Ba0qBaBB2bBf1a"
	#var puzzle_code = "10x10:a0c0cBh0d0Bg1d3hBa2b3a1h3d2g02dBhBc0c0a"
	#var puzzle_code = "10x10:mBaBBeBd1c2c2b1bBa2l1aBbBb4c2c1dBe0BaBm"
	#var puzzle_code = "10x10:aBcBb1aBh1c2aB0e1dBb1a1aB2h1BaBaBbBd1e02a1c1hBaBb0cBa"
	#var puzzle_code = "10x10:cBbBe1a0Bb3b01k2jBa00bBBa1j2kBBb2bBBaBeBb0c"
	#var puzzle_code = "10x10:a1bBBiBb4hBd0dBaBiB1i1a1d2dBh0b0iB1b1a"
	#var puzzle_code = "10x10:c0b1dB1dBc1c1c1fBa0vBa3fBc3c0c1dB2d0b0c"
	#var puzzle_data = generate_puzzle_by_code(puzzle_code)
	#print_puzzle(puzzle_data)
	#
	#var solutions = []
	##backtrack_solver(puzzle_data, solutions)
	#backtrack_solver2(puzzle_data, solutions)
	
	#var w = 7
	#var h = 7
	#var fill_percent = 0.3
	#var edge_list = [
		#Vector2i(0,0), Vector2i(h-1,0), Vector2i(0,w-1), Vector2i(h-1,w-1),
		#Vector2i(0,1), Vector2i(h-1,1), Vector2i(0,w-2), Vector2i(h-1,w-2),
		#Vector2i(1,0), Vector2i(h-2,0), Vector2i(1,w-1), Vector2i(h-2,w-1),
	#]
	#generate_new_puzzle(Vector2i(w,w), SymmetryType.TwoWayMirror, fill_percent, edge_list)
	pass


func generate_new_puzzle(
	size:Vector2i, 
	symmetry_type:SymmetryType, 
	wall_percent:float, 
	edge_list=[],
	rand_seed=Time.get_ticks_msec()
	):
	if rand_seed:
		seed(int(rand_seed))
		
	var wall_count_required = size.x * size.y * wall_percent
	var is_valid = false
	var puzzle_data
	while not is_valid:
		# Step1
		var original_puzzle_data = generate_empty_puzzle_with_wall(size, symmetry_type, wall_count_required, edge_list)
		print("empty puzzle")
		PuzzleUtils.print_puzzle(original_puzzle_data)
		
		# Step2+3
		var init_try_count = 0
		var solution_count = 0
		
		while solution_count != 1 and init_try_count < 5:
			puzzle_data = PuzzleUtils.duplicate_obj_array(original_puzzle_data)
			gen_init_solution_and_nums(puzzle_data)
			reset_puzzle(puzzle_data)
			PuzzleUtils.print_puzzle(puzzle_data)
		
			solution_count = get_solution_count(puzzle_data)
			init_try_count += 1
		
		is_valid = solution_count == 1
		wall_count_required += 1
	##
	### Step4
	#while solution_count != 1:
		#print("init solution_count !=1, add wall")
		#adjust_puzzle_wall(original_puzzle_data, symmetry_type, wall_percent)
		#
		#puzzle_data = PuzzleUtils.duplicate_obj_array(original_puzzle_data)
		#gen_init_solution_and_nums(puzzle_data)
		#reset_puzzle(puzzle_data)
		#PuzzleUtils.print_puzzle(puzzle_data)
		#
		#solution_count = get_solution_count(puzzle_data)
		#reset_puzzle(puzzle_data)
		#PuzzleUtils.print_puzzle(puzzle_data)
	
	#
	## Step5
	polish_puzzle(puzzle_data)
	#for row in puzzle_data:
		#for cell in row:
			#if cell.type == PuzzleCell.Type.NUM:
				#var original_type = cell.type
				#var original_num = cell.num
				#cell.type = PuzzleCell.Type.BLACK
				#cell.num = -1
				#
				#if get_solution_count(puzzle_data) != 1:
					#cell.type = original_type
					#cell.num = original_num
	#
	var final_puzzle_data = PuzzleUtils.duplicate_obj_array(puzzle_data)
	var solutions = []
	var solution_logs = []
	PuzzleSolver.backtrack_solver2(puzzle_data, solutions, solution_logs)
	
	print("\n\nfinal puzzle")
	print("solutions count: ", solutions.size())
	PuzzleUtils.print_puzzle(final_puzzle_data)
	PuzzleUtils.print_puzzle(solutions[0])
	print(puzzle2code(final_puzzle_data))
	
	return final_puzzle_data
	

func generate_empty_puzzle_with_wall(size:Vector2i, symmetry_type:SymmetryType, wall_count_required:float, edge_list=[]):
	# 初始化分布权重
	height = int(size.x)
	width = int(size.y)
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
	

func polish_puzzle(puzzle_data):
	for row in puzzle_data:
		for cell in row:
			if cell.type == PuzzleCell.Type.NUM:
				var original_type = cell.type
				var original_num = cell.num
				cell.type = PuzzleCell.Type.BLACK
				cell.num = -1
				
				if get_solution_count(puzzle_data) != 1:
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
	width = puzzle_data[0].size()
	height = puzzle_data.size()
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
			print("place light at ", new_light.cell_id)
			PuzzleUtils.place_light(puzzle_data, new_light.cell_id)
		else:
			break


func gen_init_nums(puzzle_data):
	for i in height:
		for j in width:
			var curr_cell = puzzle_data[i][j] as PuzzleCell
			if curr_cell.type == PuzzleCell.Type.BLACK:
				var count = PuzzleUtils.get_light_neighbours_count(puzzle_data, curr_cell.cell_id)
				curr_cell.num = count
				curr_cell.type = PuzzleCell.Type.NUM


func get_solution_count(puzzle_data):
	return get_all_solutions(puzzle_data)[0].size()


func get_all_solutions(puzzle_data, verbose=false):
	var solutions = []
	var solution_logs = []
	PuzzleSolver.backtrack_solver2(PuzzleUtils.duplicate_obj_array(puzzle_data), solutions, solution_logs, verbose)
	print("solutions count: ", solutions.size())
	print(solution_logs)
	return [solutions, solution_logs]
	

func generate_puzzle_by_code(level_code:String):
	var grid = level_code.split(":")[0]
	var cells = level_code.split(":")[1]
	width = int(grid.split("x")[0])
	height = int(grid.split("x")[1])
	var puzzle_data = []
	for i in height:
		var row = []
		for j in width:
			row.append(null)
		puzzle_data.append(row)
		
	var row_id
	var col_id
	
	var cell_idx = 0
	for i in cells:
		match i:
			"B":
				row_id = int(cell_idx/width)
				col_id = int(cell_idx%width)
				puzzle_data[row_id][col_id] = PuzzleCell.inst(Vector2i(row_id, col_id), PuzzleCell.Type.BLACK)
				cell_idx += 1
			
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
				PuzzleCell.Type.SPEC_REPEATER: code.append("X")
				PuzzleCell.Type.SPEC_REFLECTER_135: code.append("Y")
				PuzzleCell.Type.SPEC_REFLECTER_45: code.append("Z")
			
	res = str(w) + "x" + str(h) + ":"+ "".join(code)
	return res


func reset_puzzle(puzzle_data):
	"""
	重置puzzle数据，取消 implacable, light 标记
	"""
	for row in puzzle_data:
		for cell in row:
			cell.reset()
	
