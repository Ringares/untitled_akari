extends Node2D
class_name LevelRoot

@export var GRID_SIZE = 128

func adjust_position_scale():
	var furthest_x_pos = 0.
	var furthest_y_pos = 0.
	var furthest_x_cell = 0
	var furthest_y_cell = 0
	for i in get_children():
		if i.global_position.x > furthest_x_pos:
			furthest_x_pos = i.global_position.x
			furthest_x_cell = i.cell_id.x
		if i.global_position.y > furthest_y_pos:
			furthest_y_pos = i.global_position.y
			furthest_y_cell = i.cell_id.y
	
	var board_rect = Vector2(
		furthest_x_pos + GRID_SIZE / 2.0 - global_position.x, 
		furthest_y_pos + GRID_SIZE / 2.0 - global_position.y
	)
	
	var scale_x = (get_viewport_rect().size.x * 2 / 3) / board_rect.x
	var scale_y = (get_viewport_rect().size.y * 2 / 3) / board_rect.y
	
	var final_scale = clamp(min(scale_x, scale_y), 0.1, 1.0)
	self.scale = Vector2(final_scale, final_scale)
	self.global_position = Vector2(
		get_viewport_rect().size.x / 2. - board_rect.x * final_scale / 2.,
		get_viewport_rect().size.y / 2. - board_rect.y * final_scale / 2.
	)
	
	var max_dist = 0
	for i in get_children():
		var dist = abs(furthest_x_cell / 2.0 - i.cell_id.x) + abs(furthest_y_cell / 2.0 - i.cell_id.y) 
		max_dist = max(max_dist, dist)
		i.show_up(dist)
		
	for delay in max_dist:
		await get_tree().create_timer(0.08).timeout
		SfxManager.play_light_up()
		
	
