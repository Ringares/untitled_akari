extends HBoxContainer
class_name SaveDataControl


func _ready() -> void:
	if GameLevelLog.get_passed_levels("Save1").size() > 0:
		%Button.show()
	if GameLevelLog.get_passed_levels("Save2").size() > 0:
		%Button2.show()
	if GameLevelLog.get_passed_levels("Save3").size() > 0:
		%Button3.show()


func _on_button_pressed() -> void:
	reset_data_confirm("Save1")


func _on_button_2_pressed() -> void:
	reset_data_confirm("Save2")


func _on_button_3_pressed() -> void:
	reset_data_confirm("Save3")

func reset_data_confirm(save_name):
	%ConfirmationDialog.popup_centered()
