extends Control
@onready var level_generator = $LevelGenerator

#const UI_DEFEATED = preload("res://scene/ui/ui_defeated.tscn")
#const UI_LEVEL_CLEAR = preload("res://scene/ui/ui_level_clear.tscn")
@export_file("*.tscn") var main_menu_scene : String
@export var UI_LEVEL_CLEAR: PackedScene
const PAUSE_MENU = preload("res://scenes/menu/pause_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	GameLog.game_started()

func _on_level_loader_level_load_started():
	pass # Replace with function body.


func _on_level_generator_level_loaded() -> void:
	if not GameEvents.signal_level_won.is_connected(_on_level_won):
		GameEvents.signal_level_won.connect(_on_level_won, CONNECT_ONE_SHOT)
	if not GameEvents.signal_level_advance.is_connected(_on_level_advance):
		GameEvents.signal_level_advance.connect(_on_level_advance, CONNECT_ONE_SHOT)
	if not GameEvents.signal_level_reset.is_connected(_on_level_reset):
		GameEvents.signal_level_reset.connect(_on_level_reset, CONNECT_ONE_SHOT)


func _on_level_generator_levels_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	print('game_ui _on_level_loader_levels_finished')
	SceneLoader.load_scene(main_menu_scene)


func _on_level_won():
	print('game_ui _on_level_won')
	await get_tree().create_timer(0.5).timeout
	InGameMenuController.open_menu(UI_LEVEL_CLEAR, get_viewport())
	
	
func _on_level_advance():
	print('game_ui _on_level_advance')
	level_generator.advance_and_load_level()
	
	
func _on_level_reset():
	print('game_ui _on_level_reset')
	level_generator.reset_level()


func _on_main_button_pressed() -> void:
	#SceneLoader.load_scene("res://scenes/menu/main_menu.tscn")
	SceneLoader.load_scene("res://scenes/game/game_ui/play_save_slots.tscn")


func _on_menu_button_pressed() -> void:
	InGameMenuController.open_menu(PAUSE_MENU, get_viewport())


func _on_light_mode_button_pressed() -> void:
	var new_mode = DisplayMode.switch_mode()
	
	if new_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")
