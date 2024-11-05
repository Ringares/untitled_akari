extends Control
@onready var level_loader = $LevelLoader

#const UI_DEFEATED = preload("res://scene/ui/ui_defeated.tscn")
#const UI_LEVEL_CLEAR = preload("res://scene/ui/ui_level_clear.tscn")
@export_file("*.tscn") var main_menu_scene : String
@export var UI_LEVEL_CLEAR: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	GameLog.game_started()
	GameEvents.signal_level_jump_to.connect(_signal_level_jump_to)


func _on_level_loader_level_load_started():
	pass # Replace with function body.


func _on_level_loader_level_loaded():
	#await level_loader.current_level.ready
		
	if not GameEvents.signal_level_won.is_connected(_on_level_won):
		GameEvents.signal_level_won.connect(_on_level_won, CONNECT_ONE_SHOT)
	if not GameEvents.signal_level_advance.is_connected(_on_level_advance):
		GameEvents.signal_level_advance.connect(_on_level_advance, CONNECT_ONE_SHOT)
	if not GameEvents.signal_level_reset.is_connected(_on_level_reset):
		GameEvents.signal_level_reset.connect(_on_level_reset, CONNECT_ONE_SHOT)
	if not GameEvents.signal_levels_finished.is_connected(_on_level_finished):
		GameEvents.signal_levels_finished.connect(_on_level_finished, CONNECT_ONE_SHOT)


func _signal_level_jump_to(id:int):
	level_loader.jump_level(id)

func _on_level_loader_levels_finished():
	await get_tree().create_timer(0.5).timeout
	print('game_ui _on_level_loader_levels_finished')
	SceneLoader.load_scene(main_menu_scene)


func _on_level_won():
	print('game_ui _on_level_won')
	await get_tree().create_timer(0.5).timeout
	InGameMenuController.open_menu(UI_LEVEL_CLEAR, get_viewport())
	
	
func _on_level_advance():
	print('game_ui _on_level_advance')
	level_loader.advance_and_load_level()
	
	
func _on_level_reset():
	print('game_ui _on_level_reset')
	level_loader.load_level()
	
func _on_level_finished():
	SceneLoader.load_scene("res://scenes/game/game_ui/play_save_slots.tscn")
