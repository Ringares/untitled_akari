extends CanvasLayer

@export var options_packed_scene : PackedScene
@export_file("*.tscn") var main_menu_scene : String
const LEVEL_SELECTOR = preload("res://scenes/game/level_selector.tscn")

var curr_container

# Called when the node enters the scene tree for the first time.
func _ready():
	if options_packed_scene == null:
		%OptionButton.hide()
	else:
		pass
		#var options_scene = options_packed_scene.instantiate()
		#options_scene.is_from_main_menu = false
		#%OptionVBox.call_deferred("add_child", options_scene)
		#%OptionVBox.call_deferred("move_child", options_scene, 1)
	
	if main_menu_scene.is_empty():
		%MainMenuButton.hide()
	
	#curr_container = %MenuContainer
	#%OptionContainer.hide()
	InGameMenuController.scene_tree = get_tree()


#func _open_sub_menu():
	#curr_container.show()
	#%MenuContainer.hide()
	

#func _close_sub_menu():
	#curr_container.hide()
	#curr_container = %MenuContainer
	#%MenuContainer.show()

func _on_resume_button_pressed():
	InGameMenuController.close_menu()


func _on_restart_button_pressed():
	InGameMenuController.close_menu()
	SceneLoader.reload_current_scene()


func _on_option_button_pressed():
	#curr_container = %OptionContainer
	#_open_sub_menu()
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner != null:
		print(focus_owner, 'release_focus')
		focus_owner.focus_mode = Control.FocusMode.FOCUS_NONE
		focus_owner.release_focus()
	
	var options_scene = options_packed_scene.instantiate()
	options_scene.is_from_main_menu = false
	add_child(options_scene)
	
	#call_deferred("add_child", options_scene)
	#%OptionVBox.call_deferred("move_child", options_scene, 1)


func _on_main_menu_button_pressed():
	SceneLoader.load_scene(main_menu_scene)
	#InGameMenuController.close_menu()


#func _on_back_button_pressed():
	#_close_sub_menu()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		InGameMenuController.close_menu()


func _on_level_selector_pressed() -> void:
	get_parent().add_child(LEVEL_SELECTOR.instantiate())
	InGameMenuController.close_menu()
	
