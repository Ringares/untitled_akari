@tool
extends Node

signal level_load_started
signal level_loaded
signal levels_finished

const LEVEL_BASE_SCENE = preload("res://scenes/game/level/level_base_scene.tscn")


@export var auto_load : bool = true
@export var level_container:SubViewport
var current_level:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if auto_load:
		load_level()


func jump_level(level_id : int):
	_clear_current_level()
	var current_level_data = get_level_file(level_id)
	current_level = _attach_level(current_level_data, level_id)
	GameLevelLog.level_reached(level_id)
	emit_signal("level_loaded")


func load_level(level_id : int = get_current_level_id()):
	_clear_current_level()
	var current_level_data = get_level_file(level_id)
	current_level = _attach_level(current_level_data, level_id)
	emit_signal("level_loaded")


func _attach_level(level_resource, level_id):
	assert(level_container != null, "level_container is null")
	
	var instance = LEVEL_BASE_SCENE.instantiate()
	instance.current_level_id_str = LevelRes.get_levels()[level_resource]
	#instance.packed_level = load(level_resource)
	instance.level_code = level_resource
	level_container.call_deferred("add_child", instance)
	return instance


func _clear_current_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	current_level = null
	

func get_current_level_id() -> int:
	return GameLevelLog.get_current_level()


func get_level_file(level_id : int = get_current_level_id()):
	if LevelRes.get_levels().is_empty():
		push_error("files is empty")
		return
	if level_id >= LevelRes.get_levels().size():
		push_error("level_id is greater than files size")
		return
	return LevelRes.get_levels().keys()[level_id]


func advance_level() -> bool:
	var level_id : int = get_current_level_id()
	var level_code = LevelRes.get_levels().keys()[level_id]
	var level_id_str = LevelRes.get_levels()[level_code]
	var level_world = int(level_id_str.split('-')[0])
	var level_in_world = int(level_id_str.split('-')[1])
	#match level_in_world:
		#23: SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W0_COMPLETE)
		#47: SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W1_COMPLETE)
		#71: SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W2_COMPLETE)
		#95: SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W3_COMPLETE)
		#119: SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W4_COMPLETE)
		#143: SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W5_COMPLETE)
	#
	print("level passed ", level_id_str)
	GameLevelLog.append_passed_level(level_id_str)
	if check_world_cleared(0):
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W0_COMPLETE)
	if check_world_cleared(1):
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W1_COMPLETE)
	if check_world_cleared(2):
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W2_COMPLETE)
	if check_world_cleared(3):
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W3_COMPLETE)
	if check_world_cleared(4):
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W4_COMPLETE)
	if check_world_cleared(5):
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.W5_COMPLETE)
	
	
	if GameLevelLog.get_passed_levels().size() >= 48:
		GameLevelLog.set_infinite_mode_unlocked()
		SteamUtils.set_achievement(SteamUtils.ACHIEVEMENT_ENUM.INFINITE_UNLOCK)
		
	
	level_id += 1
	if level_id >= LevelRes.get_levels().size():
		emit_signal("levels_finished")
		GameLevelLog.set_is_levels_finished(true)
		GameEvents.signal_levels_finished.emit()
		level_id = LevelRes.get_levels().size() - 1
		return false
	GameLevelLog.level_reached(level_id)
	return true
	
func advance_and_load_level():
	if advance_level():
		load_level()


func check_world_cleared(world_id:int):
	var passed = GameLevelLog.get_passed_levels()
	for i in range(24*world_id, 24*(world_id+1)):
		#print('check pass ', "%d-%d" % [world_id, i])
		if "%d-%d" % [world_id, i] not in passed:
			return false
	return true
		
