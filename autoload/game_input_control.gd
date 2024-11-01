extends Node

enum INPUT_SCHEMES { KEYBOARD_AND_MOUSE, GAMEPAD, TOUCH_SCREEN }
var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.KEYBOARD_AND_MOUSE

var input_ctrl_nodes = []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and INPUT_SCHEME != INPUT_SCHEMES.KEYBOARD_AND_MOUSE:
		INPUT_SCHEME = INPUT_SCHEMES.KEYBOARD_AND_MOUSE
		print("INPUT_SCHEME switch to ", INPUT_SCHEME)
		GameEvents.signal_input_scheme_changed.emit()
		
	elif (event is InputEventJoypadMotion or event is InputEventJoypadButton) and INPUT_SCHEME != INPUT_SCHEMES.GAMEPAD:
		INPUT_SCHEME = INPUT_SCHEMES.GAMEPAD
		print("INPUT_SCHEME switch to ", INPUT_SCHEME)
		GameEvents.signal_input_scheme_changed.emit()


func is_mouse():
	return GameInputControl.INPUT_SCHEME == GameInputControl.INPUT_SCHEMES.KEYBOARD_AND_MOUSE


func is_controller():
	return GameInputControl.INPUT_SCHEME == GameInputControl.INPUT_SCHEMES.GAMEPAD

func append_input_ctrl_nodes(node:InputControl):
	input_ctrl_nodes.append
