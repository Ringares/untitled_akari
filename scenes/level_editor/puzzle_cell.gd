extends Node
class_name PuzzleCell

enum Type{
	EDGE,
	BLANK,
	NUM,
	BLACK, # B
	
	SPEC_WH, # W
	SPEC_REPEATER, # X
	SPEC_REFLECTER_135, # Y
	SPEC_REFLECTER_45, # Z
	
}
enum LIGHT_REASON{
	OTHER,
	SOLVE_ONLY_POSSIBLE,
	MATCH_NUM,
}

var cell_id = Vector2i.ZERO
var num = -1
var type:Type
var is_implacable = true
var has_light = false
var is_lit = false
var linked_cell_id = null

var has_trivialed = false  # 是否初解过
var heuristic_value = 1
var light_reason:LIGHT_REASON = LIGHT_REASON.OTHER

static func inst(cell_id, type:PuzzleCell.Type, num=-1):
	var inst = PuzzleCell.new()
	inst.cell_id = cell_id
	inst.type = type
	if type == PuzzleCell.Type.BLANK:
		inst.is_implacable = false
		
	inst.num = num
	return inst


func reset():
	if type == PuzzleCell.Type.BLANK:
		is_implacable = false
		has_light = false
		is_lit = false
		has_trivialed = false

func get_str():
	match type:
		Type.BLACK: return 'B'
		Type.NUM: return str(num)
		Type.BLANK: 
			if has_light:
				return 'x'
			elif is_lit:
				return '+'
			elif is_implacable:
				return '.'
			else:
				return '_'
		Type.EDGE: return 'E'
	return 'U'


func self_duplicate():
	var inst = PuzzleCell.new()
	inst.cell_id = self.cell_id
	inst.num = self.num
	inst.type = self.type
	inst.is_implacable = self.is_implacable
	inst.has_light = self.has_light
	inst.is_lit = self.is_lit
	inst.linked_cell_id = self.linked_cell_id 
	inst.has_trivialed = self.has_trivialed  # 是否初解过
	
	return inst
