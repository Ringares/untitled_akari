extends Node2D

@export var init_focus_node:Node

var last_controller_input = 0
const INPUT_TIME_GAP = 160


enum INPUT_SCHEMES { KEYBOARD_AND_MOUSE, GAMEPAD, TOUCH_SCREEN }
static var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.KEYBOARD_AND_MOUSE



func _ready() -> void:
	if GameInputControl.INPUT_SCHEME == GameInputControl.INPUT_SCHEMES.GAMEPAD:
		focus_next("ui_down")
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		focus_next("ui_down")
	if Input.is_action_pressed("ui_up"):
		focus_next("ui_up")
	if Input.is_action_pressed("ui_left"):
		focus_next("ui_left")
	if Input.is_action_pressed("ui_right"):
		focus_next("ui_right")
		
		
	#Get input direction and handle movement
	var mouse_sens = 1000
	var direction: Vector2
	direction.x = Input.get_action_strength("cursor_right") - Input.get_action_strength("cursor_left")
	direction.y = Input.get_action_strength("cursor_down") - Input.get_action_strength("cursor_up")
	#print("direction", direction)
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	var movement = mouse_sens * direction * delta
	if(movement):
		simu_mouse_move(movement)
		
	if Input.is_action_just_pressed("place_light"):
		GameEvents.signal_simu_event_left_clk.emit()
		#simu_left_clik()
	if Input.is_action_just_pressed("place_mark"):
		GameEvents.signal_simu_event_right_clk.emit()
		#simu_right_clik()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if %JoystickCursor:
			%JoystickCursor.global_position = get_global_mouse_position()


func simu_mouse_move(movement):
	#%JoystickCursor.show()
	if %JoystickCursor:
		%JoystickCursor.global_position = Vector2(
			clamp(%JoystickCursor.global_position.x + movement.x, 0., get_viewport_rect().size.x),
			clamp(%JoystickCursor.global_position.y + movement.y, 0., get_viewport_rect().size.y)
		)
		get_viewport().warp_mouse(%JoystickCursor.global_position)
		
		
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
		"ui_up": new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_top)
		"ui_down": new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_bottom)
		"ui_left": new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_left)
		"ui_right": new_focus_node = focus_owner.get_node(focus_owner.focus_neighbor_right)
	
	if new_focus_node:
		new_focus_node.focus_mode = Control.FocusMode.FOCUS_ALL
		focus_owner.focus_mode = Control.FocusMode.FOCUS_NONE
		new_focus_node.grab_focus()
		
		last_controller_input = Time.get_ticks_msec()
