extends Node

# Audio signals
signal signal_example

var num_players = 8
var bus = "SFX"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.
var last_sfx_played = {}

var min_sfx_pitch

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", _on_stream_finished.bind(p))
		p.bus = bus
	
	# connect("signal_play_enemy_hit", _on_play_enemy_hit)


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func _play(sound_path):
	queue.append(sound_path)


func _physics_process(delta: float) -> void:
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		#print(Time.get_ticks_msec())
		var sfx_path = queue.pop_front()
		if sfx_path in last_sfx_played:
			if Time.get_ticks_msec() - last_sfx_played[sfx_path] < 35:
				#print("skip sfx")
				return
		
		
		last_sfx_played[sfx_path] = Time.get_ticks_msec()
		available[0].stream = load(sfx_path)
		available[0].play()
		available.pop_front()
		
	
func reset():
	for i in available:
		(i as AudioStreamPlayer).stop()


func play_akari_drop():
	#_play("res://assets/audio/game_sfx/akari_drop.wav")
	_play("res://assets/audio/game_sfx/FUI Button Beep Clean.wav")
	
func play_light_up():
	_play("res://assets/audio/game_sfx/lightup_tiny.wav")

func play_hover():
	_play("res://assets/audio/ui_audio/ui_hover.ogg")
