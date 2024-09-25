@tool
extends MarginContainer
class_name SaveSlot

@export var save_name:String = "test"
@export_file("*.tscn") var game_scene_path : String
@export var show_name:String:
	set(value):
		show_name = value
		%SlotButton.text = show_name


var reseting = false


func _ready() -> void:
	init_save_slot()


func _process(delta: float) -> void:
	if not %Timer.is_stopped():
		#print(%Timer.time_left)
		%ProgressBar.value = (1 - %Timer.time_left / %Timer.wait_time) * 100



func init_save_slot():
	assert(save_name)
	var level_passed_size = GameLevelLog.get_passed_levels(save_name).size()
	print(level_passed_size, LevelRes.get_level_size(), int(level_passed_size * 100 / LevelRes.get_level_size()))
	%SlotFinishedLabel.text = str(int(level_passed_size * 100 / LevelRes.get_levels().size() )) + " %"
	
	#%RestButton.hide()
	%ProgressBar.value = 0
	%ProgressBar.hide()
	
	if level_passed_size > 0:
		#%RestButton.show()
		%Timer.timeout.connect(
			func():
				print("Timer.timeout")
				GameLevelLog.reset_save_slot(save_name)
				init_save_slot()
		)

func _on_slot_button_pressed() -> void:
	GameLevelLog.set_curr_save(save_name)
	SceneLoader.load_scene(game_scene_path)


func _on_rest_button_button_down() -> void:
	print("_on_rest_button_button_down")
	%Timer.start()
	%ProgressBar.show()

func _on_rest_button_button_up() -> void:
	print("_on_rest_button_button_up")
	%Timer.stop()
	%ProgressBar.hide()
	%ProgressBar.value = 0
