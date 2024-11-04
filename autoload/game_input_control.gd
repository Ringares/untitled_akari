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
	input_ctrl_nodes.append(node)
	check_visibility()
	

func pop_input_ctrl_nodes(node:InputControl):
	input_ctrl_nodes.erase(node)
	check_visibility()
	
func check_visibility():
	var s = input_ctrl_nodes.size()
	var has_enabled = false
	for i in range(s-1, -1, -1):
		print('check_visibility for idx =', i)
		var input_ctrl_node = input_ctrl_nodes[i] as InputControl
		if is_instance_valid(input_ctrl_node):
			if not has_enabled and input_ctrl_node.is_visible_in_tree():
				input_ctrl_node.enabled = true
				has_enabled = true
			else:
				input_ctrl_node.enabled = false
