#extends TileMapLayer
#class_name TileMapLayerGenerator
#
#const GROUND = preload("res://scenes/game/components/ground.tscn")
#
#const OBSTACLE_NUM = preload("res://scenes/game/components/obstacle_num.tscn")
#const OBSTACLE_REFLECTER = preload("res://scenes/game/components/obstacle_reflecter.tscn")
#const OBSTACLE_REPEATER = preload("res://scenes/game/components/obstacle_repeater.tscn")
#
#
#@export var level_container:Node2D
#
#var tile_rect:Rect2i
#var tile_size:Vector2i
#var cell_data = []
#
#var atlas_coords = {
	#Vector2i(0,0): GROUND,
	#
	#Vector2i(0,1): OBSTACLE_NUM,
	#Vector2i(1,1): OBSTACLE_NUM,
	#Vector2i(2,1): OBSTACLE_NUM,
	#Vector2i(3,1): OBSTACLE_NUM,
	#Vector2i(4,1): OBSTACLE_NUM,
	#Vector2i(5,1): OBSTACLE_NUM,
	#
	#Vector2i(1,2): OBSTACLE_REPEATER,
	#Vector2i(2,2): OBSTACLE_REFLECTER,
#}
#
#func _ready() -> void:
	#tile_rect = self.get_used_rect()
	#tile_size = self.tile_set.tile_size
	## 计算 tile 居中位置
	#if level_container == null:
		#self.queue_free()
		#return 
		#
		#
	##level_container.global_position = get_viewport_rect().size / 2 - Vector2(tile_rect.size * tile_size / 2)
	#init_level()
	#
#
#func init_level():
	#self.hide()
	#for i in range(tile_rect.size.x):
		#var l = []
		#for j in range(tile_rect.size.y):
			#l.append(null)
		#cell_data.append(l)
	#
	#for atlas_coord in atlas_coords:
		#print(atlas_coord)
		#for cell_id in self.get_used_cells_by_id(0, atlas_coord):
			#var cell_scene = atlas_coords[atlas_coord].instantiate()
			#level_container.add_child(cell_scene)
			#cell_scene.position = self.map_to_local(cell_id)
			#cell_data[cell_id.x][cell_id.y] = cell_scene
			#cell_scene.cell_id = cell_id
			#
			#if cell_scene is ObstacleNum:
				#(cell_scene as ObstacleNum).hint_num = atlas_coord.x
			#
			##if cell_scene is Ground and (cell_scene.cell_id.x + cell_scene.cell_id.y) % 2 ==0:
				##cell_scene.modulate = Color("#eeeeee")
				#
			#if cell_scene is ObstacleReflecter:
				#var alternate_id = self.get_cell_alternative_tile(cell_id)
				#var is_flip_h = alternate_id&TileSetAtlasSource.TRANSFORM_FLIP_H > 0
				#var is_flip_v = alternate_id&TileSetAtlasSource.TRANSFORM_FLIP_V > 0
				#var is_transpose = alternate_id&TileSetAtlasSource.TRANSFORM_TRANSPOSE > 0
				#
				#var direction_info = TileUtils.get_rotation(is_flip_h, is_flip_v, is_transpose)
				#print(cell_id, direction_info)
				#if not is_equal_approx(fmod(direction_info[0], PI), 0.0):
					#cell_scene.rotate90()
	#self.queue_free()
	#level_container.adjust_position_scale()
