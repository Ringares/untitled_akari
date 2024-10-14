extends Obstacle
class_name ObstacleReflecter

func get_class_name(): return "ObstacleReflecter"


@export var degree_set: ReflectUtils.DEGREE_SET = ReflectUtils.DEGREE_SET.DEG_135:
	set(value):
		degree_set = value
		match degree_set:
			ReflectUtils.DEGREE_SET.DEG_135:
				rotation = 0
			ReflectUtils.DEGREE_SET.DEG_45:
				rotation = PI / 2


func swicth_degree_set():
	if degree_set ==  ReflectUtils.DEGREE_SET.DEG_135:
		degree_set = ReflectUtils.DEGREE_SET.DEG_45
	elif degree_set == ReflectUtils.DEGREE_SET.DEG_45:
		degree_set = ReflectUtils.DEGREE_SET.DEG_135


func to_puzzle_cell():
	match degree_set:
		ReflectUtils.DEGREE_SET.DEG_135:
			return PuzzleCell.inst(Vector2i(cell_id.y, cell_id.x), PuzzleCell.Type.SPEC_REFLECTER_135)
		ReflectUtils.DEGREE_SET.DEG_45:
			return PuzzleCell.inst(Vector2i(cell_id.y, cell_id.x), PuzzleCell.Type.SPEC_REFLECTER_45)
