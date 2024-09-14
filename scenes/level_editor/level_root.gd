extends Node2D
class_name LevelRoot

@export var GRID_SIZE = 128

func adjust_position_scale():
	var furthest_x_pos = 0.
	var furthest_y_pos = 0.
	for i in get_children():
		if i.global_position.x > furthest_x_pos:
			furthest_x_pos = i.global_position.x
		if i.global_position.y > furthest_y_pos:
			furthest_y_pos = i.global_position.y
	
	var board_rect = Vector2(
		furthest_x_pos + GRID_SIZE / 2.0 - global_position.x, 
		furthest_y_pos + GRID_SIZE / 2.0 - global_position.y
	)
	
	var scale_x = (get_viewport_rect().size.x * 2 / 3) / board_rect.x
	var scale_y = (get_viewport_rect().size.y * 2 / 3) / board_rect.y
	
	var final_scale = clamp(min(scale_x, scale_y), 0.1, 1.5)
	self.scale = Vector2(final_scale, final_scale)
	self.global_position = Vector2(
		get_viewport_rect().size.x / 2. - board_rect.x * final_scale / 2.,
		get_viewport_rect().size.y / 2. - board_rect.y * final_scale / 2.
	)
