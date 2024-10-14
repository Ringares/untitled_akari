extends Obstacle
class_name ObstacleRepeater


func get_class_name(): return "ObstacleRepeater"


func to_puzzle_cell():
	var puzzle_cell = PuzzleCell.inst(Vector2i(cell_id.y, cell_id.x), PuzzleCell.Type.SPEC_REPEATER)
	return puzzle_cell
