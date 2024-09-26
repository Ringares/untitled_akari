extends GridComponent
class_name Ground

func get_class_name(): return "Ground"

const AKARI = preload("res://scenes/game/components/akari.tscn")
const MARKER = preload("res://scenes/game/components/marker.tscn")

@onready var lighted_ground: Sprite2D = %LightedGround
@onready var normal_ground: Sprite2D = %NormalGround

@onready var ground_click_rect: ColorRect = %GroundClickRect

var marker: Marker
var akari: Akari

var is_focused = false
var is_lighted = false
var passed_lights = []
var interactable = true:
	set(value):
		interactable = value
		if value:
			ground_click_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			ground_click_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	super()
	GameEvents.signal_simu_event_left_clk.connect(func(): if is_focused:left_clk())
	GameEvents.signal_simu_event_right_clk.connect(func(): if is_focused:right_clk())

func set_last_in_parent():
	get_parent().move_child(self, get_parent().get_child_count()-1)


func left_clk():
	if marker:
		marker.queue_free()
		marker = null
		
	if akari == null:
		akari = AKARI.instantiate()
		add_child(akari)
		light_up()
		get_tree().create_timer(0.8).timeout.connect(func(): GameEvents.signal_check_win_condition.emit())
	else:
		akari.queue_free()
		akari = null
		if passed_lights.size() == 0:
			light_off()
		get_tree().create_timer(0.1).timeout.connect(func(): GameEvents.signal_check_win_condition.emit())


func right_clk():
	if akari:
		akari.queue_free()
		akari = null
		
	if marker == null:
		marker = MARKER.instantiate()
		add_child(marker)
		get_tree().create_timer(0.8).timeout.connect(func(): GameEvents.signal_check_win_condition.emit())
	else:
		marker.queue_free()
		marker = null
		get_tree().create_timer(0.1).timeout.connect(func(): GameEvents.signal_check_win_condition.emit())


func light_up():
	if not is_lighted:
		is_lighted = true
		lighted_ground.show()
		normal_ground.hide()
		SfxManager.play_light_up()


func light_off():
	is_lighted = false
	lighted_ground.hide()
	normal_ground.show()


func _on_clk_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_clk"):
		left_clk()
		#self.get_parent().move_child(self, self.get_parent().get_child_count()-1)
		
	
	if event.is_action_pressed("right_clk"):
		right_clk()


func _on_area_2d_area_entered(area: Area2D) -> void:
	passed_lights.append(area)
	light_up()


func _on_area_2d_area_exited(area: Area2D) -> void:
	passed_lights.erase(area)
	if akari == null and passed_lights.size() == 0:
		light_off()


func _on_ground_click_rect_mouse_entered() -> void:
	focus()

func _on_ground_click_rect_mouse_exited() -> void:
	unfocus()


func _on_ground_area_2d_area_entered(area: Area2D) -> void:
	focus()


func _on_ground_area_2d_area_exited(area: Area2D) -> void:
	unfocus()


func focus():
	is_focused = true
	self.modulate = Color(1.15,1.15, 1.15)
	$AnimationPlayer.play("hover")
	SfxManager.play_hover()
	
func unfocus():
	is_focused = false
	self.modulate = Color.WHITE
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")
