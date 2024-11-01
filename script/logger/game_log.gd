class_name GameLog
extends Node
## Logs total count of games started through [Config].

const GAME_LOG_SECTION = "GameLog"
const TOTAL_GAMES_STARTED = "TotalGamesStarted"

static func game_started() -> void:
	var total_games_started = Config.get_config(GAME_LOG_SECTION, TOTAL_GAMES_STARTED, 0)
	total_games_started += 1
	Config.set_config(GAME_LOG_SECTION, TOTAL_GAMES_STARTED, total_games_started)


const DAYNIGHT_MODE = "DayNightMode"
static func set_daynight_mode(value) -> void:
	Config.set_config(GAME_LOG_SECTION, DAYNIGHT_MODE, value)
	

static func get_daynight_mode():
	return Config.get_config(GAME_LOG_SECTION, DAYNIGHT_MODE, 0)


const LOCALE = "Locale"
static func set_locale(locale):
	Config.set_config(GAME_LOG_SECTION, LOCALE, locale)
	
	
static func get_locale():
	return Config.get_config(GAME_LOG_SECTION, LOCALE, "")


const GENERATE_SIZE = "GenSize"
const GENERATE_SYMMETRY = "GenSymmetry"
const GENERATE_FILL = "GenFill"
const GENERATE_DIFFI = "GenDiffi"

static func set_gen_size(item_id:int):
	Config.set_config(GAME_LOG_SECTION, GENERATE_SIZE, item_id)
	
static func get_gen_size():
	return Config.get_config(GAME_LOG_SECTION, GENERATE_SIZE, 0)

static func set_gen_symmetry(item_id:int):
	Config.set_config(GAME_LOG_SECTION, GENERATE_SYMMETRY, item_id)
	
static func get_gen_symmetry():
	return Config.get_config(GAME_LOG_SECTION, GENERATE_SYMMETRY, 0)
	
static func set_gen_fill(item_id:int):
	Config.set_config(GAME_LOG_SECTION, GENERATE_FILL, item_id)
	
static func get_gen_fill():
	return Config.get_config(GAME_LOG_SECTION, GENERATE_FILL, 0)
	
static func set_gen_diffi(item_id:int):
	Config.set_config(GAME_LOG_SECTION, GENERATE_DIFFI, item_id)
	
static func get_gen_diffi():
	return Config.get_config(GAME_LOG_SECTION, GENERATE_DIFFI, 0)

const AVAILABLE_PUZZLE_DATA = "AvailablePuzzleData"
static func get_available_puzzle_data():
	"""
	7/14
	2r/2m/4r/4m
	f2/f3
	d1/d2
	key_count = 2*4*2*2 = 32
	available_puzzle_data = {
		"7_4r_":[
			"7x7:xxxxx"
		],
	}
	"""
	return Config.get_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, {})

static func get_available_puzzle_data_by_key(key):
	return Config.get_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, {}).get(key, [])


static func pop_available_puzzle_data_by_key(key):
	var puzzle_dict = Config.get_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, {})
	var puzzle_list = puzzle_dict.get(key, []) as Array
	if puzzle_list.size() == 0:
		return null
	else:
		var puzzle = puzzle_list.pop_front()
		Config.set_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, puzzle_dict)
		return puzzle
		

static func append_available_puzzle_data(key, puzzle_code):
	var data = Config.get_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, {})
	if key not in data:
		data[key] = []
	data[key].append(puzzle_code)
	Config.set_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, data)
	

static func defered_append_available_puzzle_data(key, puzzle_code):
	var data = Config.get_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, {})
	if key not in data:
		data[key] = []
	data[key].append(puzzle_code)
	Config.set_config.call_deferred(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, data)
	#Config.set_config(GAME_LOG_SECTION, AVAILABLE_PUZZLE_DATA, data)
	
