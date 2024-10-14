@tool
extends Obstacle
class_name ObstacleEdge

func get_class_name(): return "ObstacleEdge"

func stop_notify():
	pass

func to_puzzle_cell():
	var puzzle_cell = PuzzleCell.inst(Vector2i(cell_id.y, cell_id.x), PuzzleCell.Type.EDGE)
	return puzzle_cell
