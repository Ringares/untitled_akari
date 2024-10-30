extends Control


const LEVEL_SELECTOR_BUTTON = preload("res://scenes/game/game_ui/level_selector_button.tscn")
const PAUSE_MENU = preload("res://scenes/menu/pause_menu.tscn")
@export_file("*.tscn") var infi_game_scene_path : String

@onready var ui_sound: UISound = %UISound
@onready var page_container: HBoxContainer = %PageContainer

@onready var first_page_grid_container: GridContainer = %FirstPageGridContainer
@onready var page_2_grid_container: GridContainer = %Page2GridContainer
@onready var page_3_grid_container: GridContainer = %Page3GridContainer
@onready var page_4_grid_container: GridContainer = %Page4GridContainer
@onready var page_5_grid_container: GridContainer = %Page5GridContainer
@onready var last_page_grid_container: GridContainer = %LastPageGridContainer


var level_instants = {}
var passed_level_ids = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CollectionLabel.text = str(GameLevelLog.get_passed_levels().size())
	GameEvents.signal_level_jump_to.connect(func(_id):queue_free())

	var pages = [
		first_page_grid_container,
		page_2_grid_container,
		page_3_grid_container,
		page_4_grid_container,
		page_5_grid_container,
		last_page_grid_container
	]
	for level_id_str in GameLevelLog.get_passed_levels():
		passed_level_ids.append(int(level_id_str.split("-")[1]))
	

	for i in LevelRes.get_levels().keys():
		var inst = LEVEL_SELECTOR_BUTTON.instantiate() as LevelSelector
		#inst.disabled = true
		
		var level_id_str = LevelRes.get_levels()[i] as String
		var world_id = int(level_id_str.split("-")[0])
		var level_id = int(level_id_str.split("-")[1])
		level_instants[level_id] = inst

		
		var vol_num = (pages[world_id] as GridContainer).columns
		pages[world_id].add_child(inst)
		inst.text = LevelRes.get_levels()[i]
		inst.status = LevelSelector.STATUS.LOCKED
		
		var row = int(level_id / vol_num)
		var col = int(level_id % vol_num)
		
		if (row-1)*vol_num + col in passed_level_ids:
			inst.status = LevelSelector.STATUS.UNLOCKED
		if (row+1)*vol_num + col in passed_level_ids:
			inst.status = LevelSelector.STATUS.UNLOCKED
		if row*vol_num + col - 1 in passed_level_ids:
			inst.status = LevelSelector.STATUS.UNLOCKED
		if row*vol_num + col + 1 in passed_level_ids:
			inst.status = LevelSelector.STATUS.UNLOCKED
		if level_id == 0:
			inst.status = LevelSelector.STATUS.UNLOCKED
			
	
	for level_id in passed_level_ids:
		level_instants[level_id].status = LevelSelector.STATUS.PASSED
	
	# jump to curr level page
	var curr_level_id = GameLevelLog.get_current_level()
	var level_code = LevelRes.get_levels().keys()[curr_level_id]
	var curr_level_id_str = LevelRes.get_levels()[level_code]
	var curr_world = int(curr_level_id_str.split('-')[0])
	page_container.position -= Vector2(1920,0) * curr_world
	
	# process infinite mode button
	var is_infinite_mode_unlocked = GameLevelLog.get_infinite_mode_unlocked()
	if is_infinite_mode_unlocked:
		%InfiniteModeButton.disabled = false
		%InfiniteModeButton.text = tr("Infinite Mode")
		%InfiniteModeButton.icon = null
	else:
		%InfiniteModeButton.disabled = true
		%InfiniteModeButton.text = tr("Infinite Mode") + "  %d/48" % [GameLevelLog.get_passed_levels().size()]
	
	
	ui_sound.install_sounds(get_parent())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		self.queue_free()


func _on_next_button_pressed() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(page_container, "position", page_container.position + Vector2(-1920,0), 0.2)


func _on_previous_button_pressed() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(page_container, "position", page_container.position + Vector2(1920,0), 0.2)


func _on_back_button_pressed() -> void:
	self.queue_free()


func _on_infinite_mode_button_pressed() -> void:
	SceneLoader.load_scene(infi_game_scene_path)
