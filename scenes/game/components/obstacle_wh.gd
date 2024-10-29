extends Obstacle
class_name ObstacleWH


var linked_wh: ObstacleWH

func get_linked_wh():
	assert(linked_wh!=null)
	return linked_wh

func get_class_name(): return "ObstacleWH"


func to_puzzle_cell():
	var puzzle_cell = PuzzleCell.inst(Vector2i(cell_id.y, cell_id.x), PuzzleCell.Type.SPEC_WH)
	puzzle_cell.linked_cell_id = Vector2i(linked_wh.cell_id.y, linked_wh.cell_id.x)
	return puzzle_cell
