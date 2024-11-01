extends Node

var thread: Thread
var terminated: bool = false
const puzzle_store_count = 10
@onready var puzzle_generator: PuzzleGenerator = $PuzzleGenerator

"""
key_count = 2*4*2*2 = 32
	7/14
	2m/2r/4m/4r
	##f2/f3
	d1/d2
"""
var all_keys = [
	"7_2r_f3_d1",
	"7_2r_f3_d2",
	"7_2m_f3_d1",
	"7_2m_f3_d2",
	"7_4r_f3_d1",
	"7_4r_f3_d2",
	"7_4m_f3_d1",
	"7_4m_f3_d2",
	
	"14_2r_f3_d1",
	"14_2r_f3_d2",
	"14_2m_f3_d1",
	"14_2m_f3_d2",
	"14_4r_f3_d1",
	"14_4r_f3_d2",
	"14_4m_f3_d1",
	"14_4m_f3_d2",
]


func _ready() -> void:
	thread = Thread.new()
	thread.start(prepare_puzzles)
	#prepare_puzzles()

func is_terminated() -> bool:
	return terminated

#this function will stop the thread
func stop() -> void:
	terminated = true

func prepare_puzzles():
	while true:
		var available_puzzle_data = GameLog.get_available_puzzle_data() as Dictionary
		for key in all_keys:
			if BgPuzzleGenerator.is_terminated():
				return
			if key not in available_puzzle_data or available_puzzle_data[key].size() < puzzle_store_count:
				print('start generating for ', key)
				generate_puzzle_for_key(key)
				print('start generating for ', key)
				generate_puzzle_for_key(key)
				print('start generating for ', key)
				generate_puzzle_for_key(key)
		print('start waiting')
		await get_tree().create_timer(5).timeout
		

func generate_puzzle_for_key(key:String):
	var d = key.split('_')[0]
	var symm = key.split('_')[1]
	var diffi = key.split('_')[3]
	var size_option = "%sx%s" % [d, d]
	var symetry_option = {"2m":0, "2r":1, "4m":2, "4r":3}[symm]
	var wall_percent_option = 0.3
	var difficulty_option = {"d1":0, "d2":1}[diffi]
	
	var size_vect = Vector2i(int(size_option.split("x")[0]), int(size_option.split("x")[1]))
	var gen_res = puzzle_generator.generate_new_puzzle(size_vect, symetry_option, wall_percent_option, [], null)
	if gen_res == null:
		pass
	else:
		var puzzle_code = puzzle_generator.puzzle2code(gen_res[0])
		var puzzle_diffi_info = gen_res[1]
		var diffi_str = 'd1' if puzzle_diffi_info["leaf_count"] == 1 else 'd2'
		var save_key = "%s_%s_f3_%s" % [d, symm, diffi_str]
		if GameLog.get_available_puzzle_data_by_key(save_key).size() < puzzle_store_count:
			print("save puzzle for key ", save_key, " ", puzzle_code)
			GameLog.defered_append_available_puzzle_data(save_key, puzzle_code)
		else:
			print('enough puzzle for ', save_key, 'discard ', puzzle_code)


func _exit_tree() -> void:
	stop()
	if thread:
		thread.wait_to_finish()
