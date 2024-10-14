extends Node
class_name ReflectUtils

enum DEGREE_SET{
	DEG_135,
	DEG_45
}

const reflect_map_135 = {
	Vector2i(Vector2.LEFT):Vector2i(Vector2.UP),
	Vector2i(Vector2.UP):Vector2i(Vector2.LEFT),
	Vector2i(Vector2.RIGHT):Vector2i(Vector2.DOWN),
	Vector2i(Vector2.DOWN):Vector2i(Vector2.RIGHT),
}

const reflect_map_45 = {
	Vector2i(Vector2.LEFT):Vector2i(Vector2.DOWN),
	Vector2i(Vector2.DOWN):Vector2i(Vector2.LEFT),
	Vector2i(Vector2.UP):Vector2i(Vector2.RIGHT),
	Vector2i(Vector2.RIGHT):Vector2i(Vector2.UP),
}


static func get_reflect_dir(degree_set, incoming_dir):
	"""
	incoming_dir: 来源相对于此的相对位置， 从左边入射
	"""
	match degree_set:
		DEGREE_SET.DEG_135:
			return reflect_map_135[incoming_dir]
		DEGREE_SET.DEG_45:
			return reflect_map_45[incoming_dir]
