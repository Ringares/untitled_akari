class_name MainMenu
extends Control

const NO_VERSION_NAME : String = "0.0.0"

@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene: PackedScene
@export var credits_packed_scene : PackedScene

@export_file("*.tscn") var options_packed_scene_path : String
@export_file("*.tscn") var credits_packed_scene_path : String


var game_scene
var options_scene
var credits_scene
var sub_menu

#@onready var continue_button = %ContinueButton
#@onready var new_game_button = %NewGameButton

@onready var option_button = %OptionsButton
@onready var exit_button = %ExitButton
@onready var version_label = %VersionLabel



func _ready():
	BgMusic.set("parameters/switch_to_clip", "MainUI")
	
	# set availabel buttons
	if OS.has_feature("web"): exit_button.hide()
	#if not game_scene_path: new_game_button.hide()
	#if not options_packed_scene:
		#option_button.hide()
	#else:
		#options_scene = options_packed_scene.instantiate()
		#%OptionVbox.call_deferred("add_child", options_scene)
		#%OptionVbox.call_deferred("move_child", options_scene, 1)
	
	#_setup_options()
	#_setup_credits()
	#curr_container = %MenuContainer
	#%OptionContainer.hide()
	#%CreditsContainer.hide()

	# set version name
	var version_name : String = ProjectSettings.get_setting("application/config/version", NO_VERSION_NAME)
	if version_name.is_empty():
		version_name = NO_VERSION_NAME
	#AppLog.version_opened(version_name)
	version_label.text = 'v ' + version_name
	

	
#func _open_sub_menu(menu : Control):
	##curr_container.show()
	#sub_menu = menu
	#sub_menu.show()
	#%BackButton.show()
	#%MenuContainer.hide()
	#
#
#func _close_sub_menu():
	#if sub_menu == null:
		#return
	#sub_menu.hide()
	#sub_menu = null
	#%BackButton.hide()
	#%MenuContainer.show()
#
#
#func _setup_options():
	#if options_packed_scene == null:
		#%OptionsButton.hide()
	#else:
		#options_scene = options_packed_scene.instantiate()
		#options_scene.hide()
		#%OptionsContainer.call_deferred("add_child", options_scene)
#
#
#func _setup_credits():
	#if credits_packed_scene == null:
		#%CreditsButton.hide()
	#else:
		#credits_scene = credits_packed_scene.instantiate()
		#credits_scene.hide()
		#if credits_scene.has_signal("end_reached"):
			#credits_scene.connect("end_reached", _on_credits_end_reached)
		#%CreditsContainer.call_deferred("add_child", credits_scene)
#
#
#func _on_credits_end_reached():
	#if sub_menu == credits_scene:
		#_close_sub_menu()


#func _on_new_game_button_pressed():
	#GameLevelLog.set_current_level(0)
	#SceneLoader.load_scene(game_scene_path)
	

#func _on_continue_button_pressed():
	#SceneLoader.load_scene(game_scene_path)




func _on_exit_button_pressed():
	get_tree().quit()

#func _on_back_button_pressed():
	#_close_sub_menu()

func _on_play_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/game_ui/play_save_slots.tscn")

func _on_option_button_pressed():
	#_open_sub_menu(options_scene)
	SceneLoader.load_scene("res://scenes/menu/option_menu/simple_option_menu.tscn")


func _on_credits_button_pressed() -> void:
	#_open_sub_menu(credits_scene)
	#credits_scene.reset()
	SceneLoader.load_scene("res://scenes/credits/credits.tscn")
