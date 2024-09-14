extends GridComponent
class_name Akari

const LIGHT_AREA = preload("res://scenes/game/components/light_area.tscn")
@export var light_strength = 8

@onready var self_area: Area2D = $SelfArea
var is_satisfied = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_light_area()


func init_light_area():
	for rotation in [0, PI/2, PI, -PI/2]:
		var light_area = LIGHT_AREA.instantiate()
		light_area.rotate(rotation)
		light_area.scale.x = light_strength
		#light_area.name = "LightArea %s" % rotation
		light_area.area_entered.connect(_on_light_area_entered.bind(light_area))
		add_child(light_area)


func _on_self_area_area_entered(_area: Area2D) -> void:
	is_satisfied = false
	self.modulate = Color.FIREBRICK


func _on_self_area_area_exited(_area: Area2D) -> void:
	is_satisfied = true
	self.modulate = Color.WHITE


func _on_light_area_entered(area: Area2D, light_area:Area2D) -> void:
	var obstacle = area.get_parent()
	print(obstacle)
	if obstacle is Obstacle:
		var distance = to_local(obstacle.global_position).distance_to(to_local((light_area.global_position)))
		print("light_area.scale", int(distance / 128) -1)
		light_area.scale.x = int(distance / 128) - 1
	
	if obstacle is ObstacleRepeater:
		for repeater_rotation in [0, -PI/2, PI/2]:
			var new_light_area = light_area.duplicate() as AkariLight
			
			new_light_area.position = new_light_area.position + to_local(obstacle.global_position) - to_local(light_area.global_position)
			new_light_area.scale.x = light_strength
			new_light_area.rotate(repeater_rotation)
			new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
			call_deferred("add_child", new_light_area)
	
	if obstacle is ObstacleReflecter:
		var light_direction = to_local(light_area.global_position).direction_to(to_local(obstacle.global_position))
		var obstacle_in_direction = - light_direction
		
		var new_light_area = light_area.duplicate() as AkariLight
		new_light_area.position = new_light_area.position + to_local(obstacle.global_position) - to_local(light_area.global_position)
		new_light_area.scale.x = light_strength
		print(light_direction, obstacle.reflect_map[obstacle_in_direction], light_direction.angle_to(obstacle.reflect_map[light_direction]))
		new_light_area.rotate(light_direction.angle_to(obstacle.reflect_map[obstacle_in_direction]))
		new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
		call_deferred("add_child", new_light_area)
	#var obstacle = area.get_parent()
	#print(obstacle)
	#if obstacle is Obstacle:
		#var distance = obstacle.global_position.distance_to(light_area.global_position)
		#print("light_area.scale", int(distance / 128) -1)
		#light_area.scale.x = int(distance / 128) - 1
	#
	#if obstacle is ObstacleRepeater:
		#for repeater_rotation in [0, -PI/2, PI/2]:
			#var new_light_area = light_area.duplicate() as AkariLight
			#new_light_area.position = new_light_area.position + (obstacle.global_position - light_area.global_position)
			#new_light_area.scale.x = light_strength
			#new_light_area.rotate(repeater_rotation)
			#new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
			#call_deferred("add_child", new_light_area)
	#
	#if obstacle is ObstacleReflecter:
		#var light_direction = light_area.global_position.direction_to(obstacle.global_position)
		#var obstacle_in_direction = - light_direction
		#
		#var new_light_area = light_area.duplicate() as AkariLight
		#new_light_area.position = new_light_area.position + (obstacle.global_position - light_area.global_position)
		#new_light_area.scale.x = light_strength
		#print(light_direction, obstacle.reflect_map[obstacle_in_direction], light_direction.angle_to(obstacle.reflect_map[light_direction]))
		#new_light_area.rotate(light_direction.angle_to(obstacle.reflect_map[obstacle_in_direction]))
		#new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
		#call_deferred("add_child", new_light_area)
		
