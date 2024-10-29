extends Node2D
class_name Akari

const LIGHT_AREA = preload("res://scenes/game/components/light_area.tscn")
@onready var showup_anim_player: AnimationPlayer = $ShowUpAnimPlayer
@onready var notify_anim_player: AnimationPlayer = $NotifyAnimPlayer
@onready var self_area: Area2D = $SelfArea
@onready var sprite_2d: Sprite2D = $Sprite2D

var light_direction = [0, 90, 180, -90]

var is_satisfied:bool:
	get():
		if connected_akari.size() == 0:
			return true
		else:
			return false
var connected_akari = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#init_light_area()
	pass


func init_light_area():
	SfxManager.play_akari_drop()
	for r in light_direction:
		var light_area = LIGHT_AREA.instantiate()
		light_area.rotate(deg_to_rad(r))
		
		#light_area.name = "LightArea %s" % r
		light_area.area_entered.connect(_on_light_area_entered.bind(light_area))
		add_child(light_area)
		light_area.start_spread()


func notify():
	if notify_anim_player.is_playing():
		notify_anim_player.stop()
	notify_anim_player.play("notify")

func stop_notify():
	notify_anim_player.stop()
	notify_anim_player.play("RESET")
	

func _on_self_area_area_entered(area: Area2D) -> void:
	connected_akari.append(area)
	if connected_akari.size() > 0:
		self.modulate = Color("#626262")


func _on_self_area_area_exited(area: Area2D) -> void:
	connected_akari.erase(area)
	if connected_akari.size() == 0:
		self.modulate = Color.WHITE


func _on_light_area_entered(area: Area2D, light_area:AkariLight) -> void:
	var obstacle = area.get_parent()
	#print(obstacle)
	if obstacle is Obstacle:
		var distance = to_local(obstacle.global_position).distance_to(to_local((light_area.global_position)))
		#print("light_area.scale", distance, " ", round(distance / 128) -1)
		#light_area.scale.x = int(distance / 128) - 1
		light_area.stop_spread(max(round(distance / 128) - 1, 0))
		#if int(distance / 128) - 1 < 0:
			#return
	await get_tree().create_timer(0.2).timeout
	
	if obstacle is ObstacleWH:
		var new_light_area = light_area.duplicate() as AkariLight
		new_light_area.scale.x = 1.0
		new_light_area.position = new_light_area.position + to_local(obstacle.get_linked_wh().global_position) - to_local(light_area.global_position)
		new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
		call_deferred("add_child", new_light_area)
		new_light_area.call_deferred("start_spread")
	
	if obstacle is ObstacleRepeater:
		#print("_on_light_area_entered", light_area)
		for repeater_rotation in [0, -PI/2, PI/2]:
			var new_light_area = light_area.duplicate() as AkariLight
			new_light_area.scale.x = 1.0
			#print("new_light_area", new_light_area)
			
			new_light_area.position = new_light_area.position + to_local(obstacle.global_position) - to_local(light_area.global_position)
			new_light_area.rotate(repeater_rotation)
			new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
			call_deferred("add_child", new_light_area)
			new_light_area.call_deferred("start_spread")
	
	if obstacle is ObstacleReflecter:
		var light_direction = to_local(light_area.global_position).direction_to(to_local(obstacle.global_position))
		light_direction = snapped(light_direction, Vector2.ONE)
		
		var obstacle_in_direction = - light_direction
		
		var new_light_area = light_area.duplicate() as AkariLight
		new_light_area.scale.x = 1.0
		new_light_area.position = new_light_area.position + to_local(obstacle.global_position) - to_local(light_area.global_position)
		#print(light_direction, obstacle.reflect_map[obstacle_in_direction], light_direction.angle_to(obstacle.reflect_map[light_direction]))
		#new_light_area.rotate(light_direction.angle_to(obstacle.reflect_map[obstacle_in_direction]))
		new_light_area.rotate(light_direction.angle_to(ReflectUtils.get_reflect_dir(obstacle.degree_set, Vector2i(obstacle_in_direction))))
		new_light_area.area_entered.connect(_on_light_area_entered.bind(new_light_area))
		call_deferred("add_child", new_light_area)
		new_light_area.call_deferred("start_spread")
