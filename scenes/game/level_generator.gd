@tool
extends Node

signal level_load_started
signal level_loaded
signal levels_finished

const LEVEL_BASE_SCENE = preload("res://scenes/game/level/level_base_scene.tscn")
@onready var size_option_button: OptionButton = %SizeOptionButton
@onready var symetry_option_button: OptionButton = %SymetryOptionButton
@onready var percent_option_button: OptionButton = %PercentOptionButton
@onready var difficulty_option_button: OptionButton = %DifficultyOptionButton
@onready var seed_edit: TextEdit = %SeedEdit

@onready var puzzle_generator: PuzzleGenerator = %PuzzleGenerator
@onready var ui_layer: CanvasLayer = %UILayer
@onready var sub_viewport_container: SubViewportContainer = %SubViewportContainer
@onready var level_container: SubViewport = %SubViewport

var current_level:Node
var curr_puzzle_code:String

func _ready() -> void:
	size_option_button.selected = GameLog.get_gen_size()
	symetry_option_button.selected = GameLog.get_gen_symmetry()
	percent_option_button.selected = GameLog.get_gen_fill()
	difficulty_option_button.selected = GameLog.get_gen_diffi()

func load_level():
	_clear_current_level()
	curr_puzzle_code = _gen_puzzle()
	current_level = _attach_level(curr_puzzle_code)
	ui_layer.hide()
	emit_signal("level_loaded")


func reset_level():
	_clear_current_level()
	current_level = _attach_level(curr_puzzle_code)
	emit_signal("level_loaded")
	

func _gen_puzzle():
	var size_option = ["7x7", "10x10"][size_option_button.get_selected_id()]
	var symetry_option = symetry_option_button.get_selected_id()
	var wall_percent_option = [0.2,0.3][percent_option_button.get_selected_id()]
	var difficulty_option = difficulty_option_button.get_selected_id()
	var seed_option = seed_edit.text
	
	#var size_vect = Vector2i(int(size_option.split("x")[0]), int(size_option.split("x")[1]))
	#var gen_res = puzzle_generator.generate_new_puzzle(size_vect, symetry_option, wall_percent_option, [], seed_option)
	#var puzzle_data = gen_res[0]
	#var puzzle_diffi_info = gen_res[1]
	#var puzzle_code = puzzle_generator.puzzle2code(puzzle_data)
	
	#print("_gen_puzzle")
	#PuzzleUtils.print_puzzle(puzzle_data)
	#print(puzzle_code)
	
	var gen_key = "%s_%s_f3_%s" % [size_option.split("x")[0], ["2m", "2r", "4m", "4r"][symetry_option], ["d1","d2"][difficulty_option]]# 14_2m_f3_d1
	var puzzle_code = GameLog.pop_available_puzzle_data_by_key(gen_key)
	print("_gen_puzzle %s, %s" % [gen_key, puzzle_code])
	return puzzle_code
	

func _attach_level(puzzle_code):
	assert(level_container != null, "level_container is null")
	
	var instance = LEVEL_BASE_SCENE.instantiate()
	instance.current_level_id_str = "Infinite Mode"
	instance.level_code = puzzle_code
	sub_viewport_container.show()
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
	#var puzzle_code = get_current_puzzle_code()
	#GameLevelLog.append_passed_gen_puzzle_code(puzzle_code)
	return true
	
func advance_and_load_level():
	if advance_level():
		load_level()


func _on_generate_button_pressed() -> void:
	GameLog.set_gen_size(size_option_button.get_selected_id())
	GameLog.set_gen_symmetry(symetry_option_button.get_selected_id())
	GameLog.set_gen_fill(percent_option_button.get_selected_id())
	GameLog.set_gen_diffi(difficulty_option_button.get_selected_id())
	
	load_level()
