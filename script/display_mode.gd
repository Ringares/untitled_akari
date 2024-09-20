extends Node
class_name DisplayMode

enum DaynightMode {
	DAY = 0, 
	NIGHT = 1,
}


static func switch_mode():
	var curr_mode = GameLog.get_daynight_mode()
	var new_mode = 1-curr_mode
	GameLog.set_daynight_mode(new_mode)
	GameEvents.signal_daynight_mode_changed.emit()
	return new_mode
