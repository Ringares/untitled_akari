extends Node
class_name UISound

@export var root_path:NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(root_path != null, "Empty root path for UISound")
	
	install_sounds(get_node(root_path))


func install_sounds(node:Node):
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect(func(): SfxManager.play_ui_hover())
			i.pressed.connect(func(): SfxManager.play_ui_click())
		
		install_sounds(i)
