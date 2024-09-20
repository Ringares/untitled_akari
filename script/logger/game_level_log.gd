class_name GameLevelLog
extends GameLog
## Extends [GameLog] to log current and max level reached through [Config]. 


const CURRENT_SAVE = "CurrentSave"
static func set_curr_save(save_name):
	Config.set_config(GAME_LOG_SECTION, CURRENT_SAVE, save_name)


static func get_curr_save():
	return Config.get_config(GAME_LOG_SECTION, CURRENT_SAVE, "DefaultSave")


const MAX_LEVEL_REACHED = "MaxLevelReached"
const CURRENT_LEVEL = "CurrentLevel"

static func level_reached(level_number : int) -> void:
	var max_level_reached = Config.get_config(GAME_LOG_SECTION, MAX_LEVEL_REACHED + "_" + get_curr_save(), 0)
	max_level_reached = max(level_number, max_level_reached)
	Config.set_config(GAME_LOG_SECTION, CURRENT_LEVEL + "_" + get_curr_save(), level_number)
	Config.set_config(GAME_LOG_SECTION, MAX_LEVEL_REACHED + "_" + get_curr_save(), max_level_reached)

static func get_max_level_reached() -> int:
	return Config.get_config(GAME_LOG_SECTION, MAX_LEVEL_REACHED + "_" + get_curr_save(), 0)

static func get_current_level() -> int:
	return Config.get_config(GAME_LOG_SECTION, CURRENT_LEVEL + "_" + get_curr_save(), 0)

static func set_current_level(level_number : int) -> void:
	Config.set_config(GAME_LOG_SECTION, CURRENT_LEVEL + "_" + get_curr_save(), level_number)

const LEVEL_PASSED = "LevelPassed"

static func append_passed_level(level_id):
	var passed_level = get_passed_levels()
	if level_id not in passed_level:
		passed_level.append(level_id)
		Config.set_config(GAME_LOG_SECTION, LEVEL_PASSED + "_" + get_curr_save(), passed_level)
	

static func get_passed_levels() -> Array:
	return Config.get_config(GAME_LOG_SECTION, LEVEL_PASSED + "_" + get_curr_save(), [])
	
