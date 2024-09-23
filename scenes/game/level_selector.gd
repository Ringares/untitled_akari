extends Control


const LEVEL_SELECTOR_BUTTON = preload("res://scenes/game/game_ui/level_selector_button.tscn")

@onready var ui_sound: UISound = %UISound
@onready var page_container: HBoxContainer = %PageContainer
@onready var page_1_grid_container: GridContainer = %Page1GridContainer
@onready var page_2_grid_container: GridContainer = %Page2GridContainer
@onready var page_3_grid_container: GridContainer = %Page3GridContainer

var level_instants = {}
var passed_level_ids = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CollectionLabel.text = str(GameLevelLog.get_passed_levels().size())
	GameEvents.signal_level_jump_to.connect(func(_id):queue_free())

	var pages = [
		page_1_grid_container,
		page_2_grid_container,
		page_3_grid_container
	]
	for level_id_str in GameLevelLog.get_passed_levels():
		passed_level_ids.append(int(level_id_str.split("-")[1]))
	

	for i in LevelRes.levels.keys():
		var inst = LEVEL_SELECTOR_BUTTON.instantiate() as LevelSelector
		#inst.disabled = true
		
		var level_id_str = LevelRes.levels[i] as String
		var world_id = int(level_id_str.split("-")[0])
		var level_id = int(level_id_str.split("-")[1])
		level_instants[level_id] = inst

		
		var vol_num = (pages[world_id] as GridContainer).columns
		pages[world_id].add_child(inst)
		inst.text = LevelRes.levels[i]
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
