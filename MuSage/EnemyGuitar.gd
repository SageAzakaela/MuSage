extends Node

@export var BPM : int = 120  # Beats per minute
@export var patterns: Array[Pattern] = []  # Array of patterns the enemy can play
@export var bars_per_cycle: int = 16  # Number of bars after which the enemy plays a pattern

@onready var _a = $_A
@onready var _s = $_S
@onready var _d = $_D
@onready var _f = $_F
@onready var _j = $_J
@onready var _k = $_K
@onready var _l = $_L
@onready var _colon = $_colon
@onready var _q = $_Q
@onready var _w = $_W
@onready var _e = $_E
@onready var _r = $_R
@onready var _u = $_U
@onready var _i = $_I
@onready var _o = $_O
@onready var _p = $_P

# Variables to manage time and state
var beat_interval = 0.0
var time_since_last_note = 0.0
var time_since_note_started = 0.0
var time_since_last_bar = 0.0
var bars_elapsed = 0
var current_pattern: Pattern = null
var current_note_index = 0

func _ready():
	# Calculate the beat interval using the BPM
	beat_interval = 60.0 / BPM  # Time for one beat in seconds

	# Choose an initial pattern
	choose_new_pattern()

func _process(delta):
	# Increment the timer for playing notes
	time_since_last_note += delta
	time_since_note_started += delta
	time_since_last_bar += delta

	# Ensure notes are played on the beat
	if current_pattern != null and time_since_last_note >= beat_interval:
		# Play the current note on the beat
		play_note_by_key(current_pattern.Sequence[current_note_index])
		
		# Move to the next note
		current_note_index += 1

		# Reset the time for the next note
		time_since_last_note = 0.0
		time_since_note_started = 0.0

		# If we've played all the notes in the pattern, reset
		if current_note_index >= current_pattern.Sequence.size():
			reset_pattern()

	# Pause the current note after half a beat duration
	if time_since_note_started >= beat_interval / 2:
		pause_all_notes()

	# Check if a bar (4 beats) has elapsed
	if time_since_last_bar >= beat_interval * 4:
		bars_elapsed += 1
		time_since_last_bar = 0.0
		
		# Check if it's time to choose a new pattern
		if bars_elapsed >= bars_per_cycle:
			bars_elapsed = 0
			choose_new_pattern()

func play_note_by_key(key: String):
	# Pause all currently playing notes
	pause_all_notes()

	# Play the corresponding note based on the key
	match key:
		"A":
			_a.play()
		"S":
			_s.play()
		"D":
			_d.play()
		"F":
			_f.play()
		"J":
			_j.play()
		"K":
			_k.play()
		"L":
			_l.play()
		";":
			_colon.play()
		"Q":
			_q.play()
		"W":
			_w.play()
		"E":
			_e.play()
		"R":
			_r.play()
		"U":
			_u.play()
		"I":
			_i.play()
		"O":
			_o.play()
		"P":
			_p.play()

func pause_all_notes():
	# Pause all audio streams
	_a.stream_paused = true
	_s.stream_paused = true
	_d.stream_paused = true
	_f.stream_paused = true
	_j.stream_paused = true
	_k.stream_paused = true
	_l.stream_paused = true
	_colon.stream_paused = true
	_q.stream_paused = true
	_w.stream_paused = true
	_e.stream_paused = true
	_r.stream_paused = true
	_u.stream_paused = true
	_i.stream_paused = true
	_o.stream_paused = true
	_p.stream_paused = true

func choose_new_pattern():
	# Randomly choose a pattern from the list
	current_pattern = patterns[randi() % patterns.size()]
	current_note_index = 0

func reset_pattern():
	# Reset the current pattern
	current_pattern = null
	current_note_index = 0
