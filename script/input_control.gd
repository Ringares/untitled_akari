extends Node2D

@export var init_focus_node:Node

var last_controller_input = 0
const INPUT_TIME_GAP = 160


enum INPUT_SCHEMES { KEYBOARD_AND_MOUSE, GAMEPAD, TOUCH_SCREEN }
static var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.KEYBOARD_AND_MOUSE



func _ready() -> void:
	if GameInputControl.INPUT_SCHEME == GameInputControl.INPUT_SCHEMES.GAMEPAD:
		focus_next("ui_down")
	

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		focus_next("ui_down")
	if Input.is_action_pressed("ui_up"):
		focus_next("ui_up")
	if Input.is_action_pressed("ui_left"):
		focus_next("ui_left")
	if Input.is_action_pressed("ui_right"):
		focus_next("ui_right")
		
		
	if Input.is_action_just_pressed("place_light") or Input.is_action_just_pressed("left_clk"):
		GameEvents.signal_simu_event_left_clk.emit()
		#simu_left_clik()
	if Input.is_action_just_pressed("place_mark") or Input.is_action_just_pressed("right_clk"):
		GameEvents.signal_simu_event_right_clk.emit()
		#simu_right_clik()
		
		
func focus_next(action:String):
	if init_focus_node == null:
		return
		
	if Time.get_ticks_msec() - last_controller_input < INPUT_TIME_GAP:
		return
	
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner == null:
		init_focus_node.focus_mode = Control.FocusMode.FOCUS_ALL
		init_focus_node.grab_focus()
		last_controller_input = Time.get_ticks_msec()
		return
	
	var new_focus_node
	match action:
		"ui_up": 
			if focus_owner.focus_neighbor_top:
				new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_top)
		"ui_down": 
			if focus_owner.focus_neighbor_bottom:
				new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_bottom)
		"ui_left": 
			if focus_owner.focus_neighbor_left:
				new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_left)
		"ui_right": 
			if focus_owner.focus_neighbor_right:
				new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_right)
	
	if new_focus_node:
		print(new_focus_node)
		new_focus_node.focus_mode = Control.FocusMode.FOCUS_ALL
		focus_owner.focus_mode = Control.FocusMode.FOCUS_NONE
		new_focus_node.grab_focus()
		
		last_controller_input = Time.get_ticks_msec()
