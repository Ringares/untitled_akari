class_name MainMenu
extends Control

const NO_VERSION_NAME : String = "0.0.0"

@export_file("*.tscn") var game_scene_path : String
@export var option_packed_scene: PackedScene

var game_scene
var option_scene
var sub_menu
var curr_container

@onready var continue_button = %ContinueButton
@onready var new_game_button = %NewGameButton

@onready var option_button = %OptionButton
@onready var exit_button = %ExitButton
@onready var version_label = %VersionLabel


func _ready():
	# set availabel buttons
	if OS.has_feature("web"): exit_button.hide()
	if not game_scene_path: new_game_button.hide()
	if not option_packed_scene:
		option_button.hide()
	else:
		option_scene = option_packed_scene.instantiate()
		%OptionVbox.call_deferred("add_child", option_scene)
		%OptionVbox.call_deferred("move_child", option_scene, 1)
		
	curr_container = %MenuContainer
	%OptionContainer.hide()
	

	# set version name
	var version_name : String = ProjectSettings.get_setting("application/config/version", NO_VERSION_NAME)
	if version_name.is_empty():
		version_name = NO_VERSION_NAME
	#AppLog.version_opened(version_name)
	version_label.text = 'v ' + version_name
	
	
func _open_sub_menu():
	curr_container.show()
	%MenuContainer.hide()
	

func _close_sub_menu():
	curr_container.hide()
	curr_container = %MenuContainer
	%MenuContainer.show()
	


func _on_new_game_button_pressed():
	GameLevelLog.set_current_level(0)
	SceneLoader.load_scene(game_scene_path)
	

func _on_continue_button_pressed():
	SceneLoader.load_scene(game_scene_path)


func _on_option_button_pressed():
	curr_container = %OptionContainer
	_open_sub_menu()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	_close_sub_menu()


func _on_light_mode_button_pressed() -> void:
	var new_mode = DisplayMode.switch_mode()
	
	if new_mode == DisplayMode.DaynightMode.DAY:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-sun-96.png")
	else:
		%LightModeButton.icon = load("res://assets/img/icon/icons8-moon-96.png")


func _on_play_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/game_ui/play_save_slots.tscn")


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.
