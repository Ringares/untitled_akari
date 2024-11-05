extends RefCounted
class_name PuzzleSolver

#static func backtrack_solver(puzzle_data, solutions):
	#"""
	#深度回溯求解
	#"""
	## 先进性初步求解
	#var trivial_result = PuzzleSolver.trivial_solver(puzzle_data)
	#var has_new_mark = trivial_result[0]
	#while has_new_mark:
		#trivial_result = PuzzleSolver.trivial_solver(puzzle_data)
		#has_new_mark = trivial_result[0]
		#
	## 取所有剩下的候选位置
	## 排序：贴着数字约束的候选位置优先级高， 数字和越大约优先
	#var candidates = trivial_result[1]
	#print(candidates.map(func(a):return a.cell_id))
	#candidates.sort_custom(
		#func(a, b): 
			#return PuzzleUtils.get_candidate_priority(puzzle_data,a.cell_id) < PuzzleUtils.get_candidate_priority(puzzle_data,b.cell_id)
	#)
	#print(candidates.map(func(a):return a.cell_id))
	#PuzzleSolver.backtrack_step(puzzle_data, candidates, solutions)
	#
	#print("solutions count: ", solutions.size())
	#for s in solutions:
		#PuzzleUtils.print_puzzle(s, ">>> after backtrack_solver")
#
#
#static func backtrack_step(puzzle_data, candidates, solutions, trace_log=""):
	##print("candidates_size", candidates.size())
	#if PuzzleUtils.check_invalid_num(puzzle_data):
		#return
		#
	#if PuzzleUtils.check_is_solved(puzzle_data):
		#if PuzzleUtils.puzzle2str(puzzle_data) not in solutions.map(PuzzleUtils.puzzle2str):
			#solutions.append(puzzle_data)
			#PuzzleUtils.print_puzzle(puzzle_data)
		#print("valid solution", trace_log)
		#return
		#
	#if candidates.size() == 0:
		#return
	#
	#var new_puzzle_data = PuzzleUtils.duplicate_obj_array(puzzle_data)
	#var new_candidates = PuzzleUtils.duplicate_obj_array(candidates)
	#var new_light = new_candidates.pop_front()
	#PuzzleUtils.place_light(new_puzzle_data, new_light.cell_id)
	#backtrack_step(new_puzzle_data, new_candidates, solutions, trace_log + "->%d:%d" % [new_light.cell_id.x, new_light.cell_id.y])
	#
	#var new_puzzle_data2 = PuzzleUtils.duplicate_obj_array(puzzle_data)
	#var new_candidates2 = PuzzleUtils.duplicate_obj_array(candidates)
	#var invlaid_light = new_candidates2.pop_front()
	#print("candidates_size ", new_candidates2.size())
	#PuzzleUtils.mark_implacable(new_puzzle_data2,invlaid_light.cell_id)
	#backtrack_step(new_puzzle_data2, new_candidates2, solutions, trace_log)
	#
	
static func backtrack_solver2(puzzle_data, solutions, solution_logs, verbose=false, gen_time_cond=null):
	backtrack_step2(puzzle_data, solutions, "", solution_logs, verbose, gen_time_cond)
	if verbose:
		print("solutions count: ", solutions.size())
		for s in solutions:
			PuzzleUtils.print_puzzle(s, ">>> after backtrack_solver")
	
	
static func backtrack_step2(puzzle_data, solutions, trace_log, solution_logs, verbose=false, gen_time_cond=null):
	if gen_time_cond != null:
		var start_msec = gen_time_cond[0]
		var threshold = gen_time_cond[1]
		if Time.get_ticks_msec() - start_msec > threshold:
			print("time's up")
			return
	if BgPuzzleGenerator.is_terminated():
		print("is_terminated")
		return
	
	# 先进性初步求解
	var depth = trace_log.split("->").size()
	var depth_prefix = ""
	for i in depth:
		depth_prefix += "\t"
	print_verbose(depth_prefix + "start backtrack_step2 ", trace_log)
	var trivial_result = trivial_solver(puzzle_data, verbose)
	var has_new_mark = trivial_result[0]
	while has_new_mark:
		trivial_result = trivial_solver(puzzle_data, verbose)
		has_new_mark = trivial_result[0]
		
	# 取所有剩下的候选位置
	# 排序：贴着数字约束的候选位置优先级高， 数字和越大约优先
	var candidates = trivial_result[1]
	var progress_count = trivial_result[2]
	print_verbose(depth_prefix + progress_count)
	
	#trace_log += "->tr:" + str(candidates.size())
	
	#print(candidates.map(func(a):return a.cell_id))
	candidates.sort_custom(
		func(a, b): 
			return PuzzleUtils.get_candidate_priority(puzzle_data,a.cell_id) < PuzzleUtils.get_candidate_priority(puzzle_data,b.cell_id)
	)
	#print(candidates.map(func(a):return a.cell_id))
	#PuzzleUtils.print_puzzle(puzzle_data)
	if PuzzleUtils.check_invalid_num(puzzle_data):
		solution_logs.append("0=>"+trace_log)
		print_verbose(depth_prefix + "end backtrack_step2 ", "0=>"+trace_log)
		return
	
	if PuzzleUtils.check_invalid_blank(puzzle_data):
		solution_logs.append("0=>"+trace_log)
		print_verbose(depth_prefix + "end backtrack_step2 ", "0=>"+trace_log)
		return
		
	if PuzzleUtils.check_is_solved(puzzle_data):
		if PuzzleUtils.puzzle2str(puzzle_data) not in solutions.map(PuzzleUtils.puzzle2str):
			solutions.append(puzzle_data)
			solution_logs.append("1=>"+trace_log)
			print_verbose(depth_prefix + "end backtrack_step2 ", "1=>"+trace_log)
			if verbose:
				PuzzleUtils.print_puzzle(puzzle_data)
				
		return
		
	if candidates.size() == 0:
		solution_logs.append("0=>"+trace_log)
		print_verbose(depth_prefix + "end backtrack_step2 ", "0=>"+trace_log)
		return

	var new_puzzle_data = PuzzleUtils.duplicate_obj_array(puzzle_data)
	var new_light = candidates.pop_front()
	PuzzleUtils.place_light(new_puzzle_data, new_light.cell_id)
	backtrack_step2(new_puzzle_data, solutions, trace_log + "->%d:%d-1" % [new_light.cell_id.x, new_light.cell_id.y], solution_logs, verbose)
	
	var new_puzzle_data2 = PuzzleUtils.duplicate_obj_array(puzzle_data)
	PuzzleUtils.mark_implacable(new_puzzle_data2,new_light.cell_id)
	backtrack_step2(new_puzzle_data2, solutions, trace_log + "->%d:%d-0" % [new_light.cell_id.x, new_light.cell_id.y], solution_logs, verbose)
	

static func trivial_solver(puzzle_data, verbose=false):
	"""
	初步求解
	"""
	var new_mark_implacable = false
	var candidates = []
	var height = puzzle_data.size()
	var width = puzzle_data[0].size()
	var unique_count
	for r in height:
		for c in width:
			var cell = puzzle_data[r][c] as PuzzleCell
			if cell.has_trivialed:
				continue
			
			if cell.type == PuzzleCell.Type.NUM:
				if cell.num == 0:
					print_verbose("trivial_solver cell ", cell.num, cell.cell_id)
					for dir in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
						new_mark_implacable = PuzzleUtils.mark_implacable(puzzle_data, Vector2i(r,c), dir) or new_mark_implacable
						print_verbose("adjust neighb cell implacable", Vector2i(r,c)+dir)
					cell.has_trivialed = true
					
					continue
				
				var placable_neighbours = PuzzleUtils.get_placable_neighbours(puzzle_data, cell.cell_id)
				var light_neighbours_count = PuzzleUtils.get_light_neighbours_count(puzzle_data, cell.cell_id)
				
				if cell.num == light_neighbours_count:
					print_verbose("trivial_solver cell", cell.num, cell.cell_id)
					for neighbour in placable_neighbours:
						new_mark_implacable = PuzzleUtils.mark_implacable(puzzle_data, neighbour.cell_id) or new_mark_implacable
						print_verbose("adjust neighbour cell implacable", neighbour.cell_id)
					cell.has_trivialed = true
					continue
				
				if placable_neighbours.size() - (cell.num - light_neighbours_count) == 1:
					print_verbose("trivial_solver cell", cell.num, cell.cell_id)
					for conner_cell_id in PuzzleUtils.get_conner_cells(cell.cell_id, placable_neighbours.map(func(a):return a.cell_id)):
						new_mark_implacable = PuzzleUtils.mark_implacable(puzzle_data, conner_cell_id) or new_mark_implacable
						print_verbose("adjust conner cell implacable", conner_cell_id)
					
				if placable_neighbours.size() - (cell.num - light_neighbours_count) == 0:
					print_verbose("trivial_solver cell", cell.num, cell.cell_id)
					for neighbour in placable_neighbours:
						new_mark_implacable = PuzzleUtils.place_light(puzzle_data, neighbour.cell_id) or new_mark_implacable
						neighbour.light_reason = PuzzleCell.LIGHT_REASON.MATCH_NUM
						print_verbose("adjust neighbour cell light", neighbour.cell_id)
					cell.has_trivialed = true
					#print("trivial_solver cell", cell.num, cell.cell_id)
					continue
			
			if cell.type == PuzzleCell.Type.BLANK and not cell.is_lit and not cell.has_light and not cell.is_implacable:
				candidates.append(cell)
	
	
	for r in height:
		for c in width:
			var cell = puzzle_data[r][c] as PuzzleCell
			if cell.type == PuzzleCell.Type.BLANK and not cell.is_lit and not cell.has_light:
					var candidate_to_light_cell = PuzzleUtils.get_candidate_to_light_cell(puzzle_data, cell.cell_id)
					if candidate_to_light_cell.size() == 1:
						if verbose:
							print("place only possible candi ", cell.cell_id, candidate_to_light_cell[0].cell_id)
						new_mark_implacable = PuzzleUtils.place_light(puzzle_data, candidate_to_light_cell[0].cell_id) or new_mark_implacable
						candidate_to_light_cell[0].light_reason = PuzzleCell.LIGHT_REASON.SOLVE_ONLY_POSSIBLE
						# temp need opti
						new_mark_implacable = true
	
	var blank_count = 0
	var lit_count = 0
	var light_count = 0
	var light_match_num = 0
	var light_match_only = 0
	var implacable_count = 0
	for r in height:
		for c in width:
			var cell = puzzle_data[r][c] as PuzzleCell
			if cell.type == PuzzleCell.Type.BLANK:
				blank_count+=1
				if cell.has_light:
					light_count += 1
					match cell.light_reason:
						PuzzleCell.LIGHT_REASON.MATCH_NUM: light_match_num += 1
						PuzzleCell.LIGHT_REASON.SOLVE_ONLY_POSSIBLE: light_match_only += 1
				elif cell.is_lit:
					lit_count += 1
				elif cell.is_implacable:
					implacable_count += 1
				
			
	if verbose:
		PuzzleUtils.print_puzzle(puzzle_data, ">>> after trivial_solver")
		print("End of trivial_solver step")
		print("")
	return [new_mark_implacable, candidates, "_".join([blank_count,light_count,lit_count,light_match_num,light_match_only,implacable_count].map(str))]
