extends Node2D
class_name LevelGround

const CURSOR = preload("res://scenes/game/components/cursor.tscn")
const GROUND = preload("res://scenes/game/components/ground.tscn")

const OBSTACLE_NUM = preload("res://scenes/game/components/obstacle_num.tscn")
const OBSTACLE_REFLECTER = preload("res://scenes/game/components/obstacle_reflecter.tscn")
const OBSTACLE_REPEATER = preload("res://scenes/game/components/obstacle_repeater.tscn")

var cursor: Cursor
@export var cursor_speed = 100

@export var tile:TileMapLayer
var tile_rect:Rect2i
var tile_size:Vector2i
var cell_data = []

var atlas_coords = {
	Vector2i(0,0): GROUND,
	
	Vector2i(0,1): OBSTACLE_NUM,
	Vector2i(1,1): OBSTACLE_NUM,
	Vector2i(2,1): OBSTACLE_NUM,
	Vector2i(3,1): OBSTACLE_NUM,
	Vector2i(4,1): OBSTACLE_NUM,
	Vector2i(5,1): OBSTACLE_NUM,
	
	Vector2i(1,2): OBSTACLE_REPEATER,
	Vector2i(2,2): OBSTACLE_REFLECTER,
}

func _ready() -> void:
	tile_rect = tile.get_used_rect()
	tile_size = tile.tile_set.tile_size
	# 计算 tile 居中位置
	self.global_position = get_viewport_rect().size / 2 - Vector2(tile_rect.size * tile_size / 2)
	
	init_level()
	#cursor = CURSOR.instantiate()
	#add_child(cursor)
	


func _process(delta: float) -> void:
	get_window().title = "Untitled Akari Game / FPS: " + str(Engine.get_frames_per_second())
	
	#if not cursor.visible:
		#cursor.show()
	#cursor.position = lerp(cursor.position, get_local_mouse_position(), cursor_speed * delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk"):
		var mouse_cell_id = tile.local_to_map(get_local_mouse_position())
		if not is_valid_cell_id(mouse_cell_id):
			return
		var pointed = cell_data[mouse_cell_id.x][mouse_cell_id.y] as GridComponent
		if pointed is Obstacle:
			return
		pointed.left_clk()
		pointed.get_parent().move_child(pointed, pointed.get_parent().get_child_count()-1)
		get_tree().create_timer(0.3).timeout.connect(check_win_condition)
	
	if event.is_action_pressed("right_clk"):
		var mouse_cell_id = tile.local_to_map(get_local_mouse_position())
		if not is_valid_cell_id(mouse_cell_id):
			return
		var pointed = cell_data[mouse_cell_id.x][mouse_cell_id.y]
		if pointed is Obstacle:
			return
		pointed.right_clk()
		get_tree().create_timer(0.3).timeout.connect(check_win_condition)
			
		


func init_level():
	for i in range(tile_rect.size.x):
		var l = []
		for j in range(tile_rect.size.y):
			l.append(null)
		cell_data.append(l)
	
	for atlas_coord in atlas_coords:
		print(atlas_coord)
		for cell_id in tile.get_used_cells_by_id(0, atlas_coord):
			var cell_scene = atlas_coords[atlas_coord].instantiate()
			add_child(cell_scene)
			cell_scene.position = tile.map_to_local(cell_id)
			cell_data[cell_id.x][cell_id.y] = cell_scene
			cell_scene.cell_id = cell_id
			
			if cell_scene is ObstacleNum:
				(cell_scene as ObstacleNum).hint_num = atlas_coord.x
			
			if cell_scene is Ground and (cell_scene.cell_id.x + cell_scene.cell_id.y) % 2 ==0:
				cell_scene.modulate = Color("#eeeeee")
				
			if cell_scene is ObstacleReflecter:
				var alternate_id = tile.get_cell_alternative_tile(cell_id)
				var is_flip_h = alternate_id&TileSetAtlasSource.TRANSFORM_FLIP_H > 0
				var is_flip_v = alternate_id&TileSetAtlasSource.TRANSFORM_FLIP_V > 0
				var is_transpose = alternate_id&TileSetAtlasSource.TRANSFORM_TRANSPOSE > 0
				
				var direction_info = TileUtils.get_rotation(is_flip_h, is_flip_v, is_transpose)
				print(cell_id, direction_info)
				if not is_equal_approx(fmod(direction_info[0], PI), 0.0):
					cell_scene.rotate90()
					
				
			
	tile.hide()
	


func check_win_condition():
	var is_win = true
	for i in get_tree().get_nodes_in_group("ground"):
		if not (i as Ground).is_lighted:
			is_win = false
			break

	for i in get_tree().get_nodes_in_group("obstacle"):
		if not (i as Obstacle).is_satisfied:
			is_win = false
			break
	
	for i in get_tree().get_nodes_in_group("akari"):
		if not (i as Akari).is_satisfied:
			is_win = false
			break
	
	print("Level Win: ", is_win)


func is_valid_cell_id(id:Vector2i):
	if id !=null and id.x >= 0 and id.x < tile_rect.size.x and id.y >=0 and id.y < tile_rect.size.y:
		return true
	else:
		return false
