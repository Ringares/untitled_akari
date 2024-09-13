extends Obstacle
class_name ObstacleReflecter


var reflect_map = {
			Vector2.LEFT:Vector2.UP,
			Vector2.UP:Vector2.LEFT,
			Vector2.RIGHT:Vector2.DOWN,
			Vector2.DOWN:Vector2.RIGHT,
		}

func rotate90():
	if rotation == 0:
		rotation = PI / 2
		
		reflect_map = {
			Vector2.LEFT:Vector2.DOWN,
			Vector2.DOWN:Vector2.LEFT,
			Vector2.UP:Vector2.RIGHT,
			Vector2.RIGHT:Vector2.UP,
		}
		
	else:
		rotation = 0
		
		reflect_map = {
			Vector2.LEFT:Vector2.UP,
			Vector2.UP:Vector2.LEFT,
			Vector2.RIGHT:Vector2.DOWN,
			Vector2.DOWN:Vector2.RIGHT,
		}
