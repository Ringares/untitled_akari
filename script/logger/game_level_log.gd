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
	var save_name =  get_curr_save()
	var passed_level = get_passed_levels(save_name)
	if level_id not in passed_level:
		passed_level.append(level_id)
		Config.set_config(GAME_LOG_SECTION, LEVEL_PASSED + "_" + save_name, passed_level)
	

static func get_passed_levels(save_name=null) -> Array:
	if save_name == null:
		save_name = get_curr_save()
	return Config.get_config(GAME_LOG_SECTION, LEVEL_PASSED + "_" + save_name, [])


const INFINITE_UNLOCKED = "InfiniteUnlocked"

static func get_infinite_mode_unlocked(save_name=null):
	if save_name == null:
		save_name = get_curr_save()
	return Config.get_config(GAME_LOG_SECTION, INFINITE_UNLOCKED + "_" + save_name, false)


static func set_infinite_mode_unlocked():
	Config.set_config(GAME_LOG_SECTION, INFINITE_UNLOCKED + "_" + get_curr_save(), true)


static func reset_save_slot(save_name):
	Config.set_config(GAME_LOG_SECTION, LEVEL_PASSED + "_" + save_name, [])
	Config.set_config(GAME_LOG_SECTION, CURRENT_LEVEL + "_" + save_name, 0)
	Config.set_config(GAME_LOG_SECTION, MAX_LEVEL_REACHED + "_" + save_name, 0)
	Config.set_config(GAME_LOG_SECTION, INFINITE_UNLOCKED + "_" + save_name, false)
	Config.set_config(GAME_LOG_SECTION, LEVELS_FINISHED + "_" + save_name, false)


const LEVELS_FINISHED = "LevelsFinished"

static func set_is_levels_finished(is_finished:bool, save_name=null):
	if save_name == null:
		save_name = get_curr_save()
	Config.set_config(GAME_LOG_SECTION, LEVELS_FINISHED + "_" + save_name, is_finished)


static func get_is_levels_finished(save_name=null):
	if save_name == null:
		save_name = get_curr_save()
	return Config.get_config(GAME_LOG_SECTION, LEVELS_FINISHED + "_" + save_name, false) 
