extends Node2D
class_name Editor


@onready var level_root: Node2D = %LevelRoot
@onready var insert_cursor: Sprite2D = %InsertCursor
@onready var selected_indicator: Sprite2D = %SelectedIndicator

const GRID_SIZE = 128
var curr_selected_tool:PackedScene:
	set(value):
		curr_selected_tool = value
		if value != null:
			curr_edit_mode = EDIT_MODE.INSERT
		else:
			curr_edit_mode = EDIT_MODE.IDEL


var mouse_rela_pos
var mouse_cell_id:Vector2i

var placed_data = {}

enum EDIT_MODE {
	IDEL,
	INSERT,
	ERASE,
	MODIFY
}

var curr_edit_mode:EDIT_MODE = EDIT_MODE.IDEL:
	set(value):
		curr_edit_mode = value
		insert_cursor.hide()
		selected_indicator.hide()
		match value:
			EDIT_MODE.IDEL: 
				%LabelEditMode.text = "EDIT_MODE.IDEL"
				pass
			EDIT_MODE.INSERT:
				%LabelEditMode.text = "EDIT_MODE.INSERT"
				insert_cursor.show()
			EDIT_MODE.ERASE:
				%LabelEditMode.text = "EDIT_MODE.ERASE"
				pass
			EDIT_MODE.MODIFY:
				%LabelEditMode.text = "EDIT_MODE.MODIFY"
				selected_indicator.show()
			


func _ready() -> void:
	EditorEvents.signal_element_selected.connect(_on_signal_element_selected)


func _process(delta: float) -> void:
	mouse_rela_pos = get_global_mouse_position() - level_root.global_position
	mouse_cell_id = local_to_grid(mouse_rela_pos)
	
	%LabelMousePos.text = "%v" % (get_global_mouse_position() - level_root.global_position)
	%LabelCell.text = "%v" % local_to_grid(mouse_rela_pos)
	
	if curr_selected_tool != null:
		insert_cursor.show()
		insert_cursor.global_position = get_global_mouse_position() 
	else:
		insert_cursor.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		curr_selected_tool = null
	
	if event.is_action_pressed("editor_erase"):
		curr_edit_mode = EDIT_MODE.ERASE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk"):
		if curr_edit_mode == EDIT_MODE.INSERT and curr_selected_tool != null:
			# insert mode
			var new_scene = curr_selected_tool.instantiate() as GridComponent
			if mouse_cell_id in placed_data:
				placed_data[mouse_cell_id].queue_free()
			
			placed_data[mouse_cell_id] = new_scene
			level_root.add_child(new_scene)
			new_scene.set_owner(level_root)
			
			new_scene.position = grid_to_local(mouse_cell_id)
		
		elif curr_edit_mode == EDIT_MODE.ERASE:
			if mouse_cell_id in placed_data:
				placed_data[mouse_cell_id].queue_free()
				
		elif curr_edit_mode in [EDIT_MODE.IDEL, EDIT_MODE.MODIFY]:
			# select mode
			curr_edit_mode = EDIT_MODE.MODIFY
			selected_indicator.global_position = to_global(grid_to_local(mouse_cell_id) + level_root.global_position)
			
	
	if event.is_action_pressed("num0"):
		set_number_obstacle_num(0)
	if event.is_action_pressed("num1"):
		set_number_obstacle_num(1)
	if event.is_action_pressed("num2"):
		set_number_obstacle_num(2)
	if event.is_action_pressed("num3"):
		set_number_obstacle_num(3)
	if event.is_action_pressed("num4"):
		set_number_obstacle_num(4)
	if event.is_action_pressed("num5"):
		set_number_obstacle_num(5)
		
	if event.is_action_pressed("rotate"):
		set_reflect_obstacle_rotate()


func set_number_obstacle_num(num:int):
	if curr_edit_mode == EDIT_MODE.MODIFY:
		var cell_id = local_to_grid(selected_indicator.global_position - level_root.global_position)
		if cell_id in placed_data and placed_data[cell_id] is ObstacleNum:
			placed_data[cell_id].hint_num = num


func set_reflect_obstacle_rotate():
	if curr_edit_mode == EDIT_MODE.MODIFY:
		var cell_id = local_to_grid(selected_indicator.global_position - level_root.global_position)
		if cell_id in placed_data and placed_data[cell_id] is ObstacleReflecter:
			placed_data[cell_id].rotate90()

	

func _on_signal_element_selected(selected:PackedScene):
	curr_selected_tool = selected


func local_to_grid(pos:Vector2):
	return Vector2i(snap(pos) / GRID_SIZE)


func snap(pos:Vector2): 
	return (pos - Vector2(GRID_SIZE/2, GRID_SIZE/2)).snapped(Vector2(GRID_SIZE, GRID_SIZE))

func grid_to_local(pos:Vector2i):
	return Vector2(pos * GRID_SIZE) + Vector2(GRID_SIZE/2, GRID_SIZE/2)


func _on_save_button_pressed() -> void:
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(%LevelRoot)
	var error = ResourceSaver.save(packed_scene, "res://scenes/level_editor/levels/test.tscn")
	if error != OK:
		push_error("An error occurred while saving the scene to disk.")
		push_error(error)


func _on_load_button_pressed() -> void:
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	pass # Replace with function body.
