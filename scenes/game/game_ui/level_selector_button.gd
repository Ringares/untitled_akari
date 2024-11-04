@tool
extends Control
class_name LevelSelector


enum STATUS{
	LOCKED,
	UNLOCKED,
	PASSED
}
var status :STATUS = STATUS.LOCKED:
	set(value):
		status = value
		match status:
			STATUS.LOCKED: 
				%Locked.show()
				%Passed.hide()
				%Unlocked.hide()
				
			STATUS.UNLOCKED: 
				%Locked.hide()
				%Passed.hide()
				%Unlocked.show()

			STATUS.PASSED: 
				%Locked.hide()
				%Passed.show()
				%Unlocked.hide()


@export var text:String:
	set(value):
		text = value
		%Label.text = value


func _on_focus_entered() -> void:
	if status != STATUS.LOCKED: 
		$AnimationPlayer.play("hover")
		self.modulate = Color(1.3,1.3, 1.3)
		SfxManager.play_hover()


func _on_focus_exited() -> void:
	$AnimationPlayer.play("RESET")
	self.modulate = Color.WHITE


func _on_mouse_entered() -> void:
	if status != STATUS.LOCKED: 
		$AnimationPlayer.play("hover")
		self.modulate = Color(1.3,1.3, 1.3)
		SfxManager.play_hover()


func _on_mouse_exited() -> void:
	$AnimationPlayer.play("RESET")
	self.modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if status != STATUS.LOCKED and event.is_action_pressed("left_clk"):
		GameEvents.signal_level_jump_to.emit(int(text.split("-")[1]))
		
	if status != STATUS.LOCKED and event.is_action_pressed("ui_accept"):
		GameEvents.signal_level_jump_to.emit(int(text.split("-")[1]))


func check_focus():
	if has_focus():
		self.modulate = Color(1.3,1.3, 1.3)
	else:
		self.modulate = Color.WHITE
	
