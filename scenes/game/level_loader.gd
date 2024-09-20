@tool
extends Node

signal level_load_started
signal level_loaded
signal levels_finished

const LEVEL_BASE_SCENE = preload("res://scenes/game/level/level_base_scene.tscn")

#var files = [
	#"res://scenes/level_editor/levels/easy/level_data_3_3_85c64f78-cc5b-4aa8-be4b-4d6d9788a1af.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_3_3_2751fec1-94c6-46f3-b0b7-f2b2db56ea6c.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_4_4_8dcd11d9-2c99-496e-9436-3548a07d889c.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_4_5_5177a867-c5e3-4a21-a1c6-337e8c23acdc.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_6_6_3b641ef5-7934-4780-86cd-2f0e092dceb5.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_6_6_18f99d6f-14c4-4adb-ba2f-d8493a4cc605.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_7_7_3d9f10e5-6e55-498b-bd0c-dd62e442e61c.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_7_7_8b06b885-4bda-4e72-bdbc-e8b9e00b3949.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_8_8_6445544d-4d89-45aa-8449-5db60fcf81bb.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_6_60d1313e-71b9-40d5-b231-f3e59b683442.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_7d7c72e7-bb94-44d0-befd-1ae79d86d245.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_11fd2cfd-e088-4cd3-b3cf-5e2d7d27174f.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_59d08e55-a06b-4816-8e1a-6a4b75d1925f.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_64be2212-9e4d-4e50-8c8a-c228feae34d2.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_78b3d552-65f7-4d79-a888-f3b6e03dbe1b.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_82c8b7ab-577d-422f-9181-40d17352f450.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_789f2b51-0e23-4fea-a755-671f9ff5c1e6.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_4333d793-c5a3-4add-b0df-07888a9a57bf.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_9964f924-6807-4881-8d31-5a8092431daf.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_ed4fa91d-3f67-48f8-9950-efc459a4d469.tscn",
	#"res://scenes/level_editor/levels/easy/level_data_10_10_f7a41a0d-f2db-45c5-92b3-c63c1250d416.tscn",
#]

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
	instance.current_level_id_str = LevelRes.levels[level_resource]
	instance.packed_level = load(level_resource)
	level_container.call_deferred("add_child", instance)
	return instance


func _clear_current_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	current_level = null
	

func get_current_level_id() -> int:
	return GameLevelLog.get_current_level()


func get_level_file(level_id : int = get_current_level_id()):
	if LevelRes.levels.is_empty():
		push_error("files is empty")
		return
	if level_id >= LevelRes.levels.size():
		push_error("level_id is greater than files size")
		return
	return LevelRes.levels.keys()[level_id]


func advance_level() -> bool:
	var level_id : int = get_current_level_id()
	var level_path = LevelRes.levels.keys()[level_id]
	var level_id_str = LevelRes.levels[level_path]
	GameLevelLog.append_passed_level(level_id_str)
	
	level_id += 1
	if level_id >= LevelRes.levels.size():
		emit_signal("levels_finished")
		level_id = LevelRes.levels.size() - 1
		return false
	GameLevelLog.level_reached(level_id)
	return true
	
func advance_and_load_level():
	if advance_level():
		load_level()
