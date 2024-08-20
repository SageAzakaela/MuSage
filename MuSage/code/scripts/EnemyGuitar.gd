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
var note_start_time = 0  # Time when the current note started playing (in milliseconds)
var current_pattern: Pattern = null
var current_note_index = 0
var note_duration = 0.0  # Duration of the current note being played (in milliseconds)
var bars_elapsed = 0
var pattern_start_time = 0  # Time when the current pattern started (in milliseconds)

func _ready():
	# Calculate the beat interval using the BPM
	beat_interval = 60.0 / BPM  # Time for one beat in seconds

	# Convert beat interval to milliseconds
	beat_interval *= 1000.0  # Convert to milliseconds

	# Choose an initial pattern
	choose_new_pattern()

func _process(delta):
	var current_time = Time.get_ticks_msec()

	if current_pattern != null and current_note_index < current_pattern.Sequence.size():
		# Check if the current note's duration has passed
		if current_time >= note_start_time + note_duration:
			# Pause the current note after its duration has passed
			pause_all_notes()

			# Move to the next note
			current_note_index += 1

			# Check if there are more notes in the sequence
			if current_note_index < current_pattern.Sequence.size():
				play_next_note()
			else:
				reset_pattern()

	# Check if a bar (4 beats) has elapsed
	if current_note_index == 0 and (current_time - pattern_start_time) >= beat_interval * 4:
		bars_elapsed += 1
		pattern_start_time = current_time  # Reset the start time for the next pattern

		# Check if it's time to choose a new pattern
		if bars_elapsed >= bars_per_cycle:
			bars_elapsed = 0
			choose_new_pattern()

func play_next_note():
	var note_info = current_pattern.Sequence[current_note_index].split("")
	var key = note_info[0]
	var duration_type = int(note_info[1])

	# Calculate the note duration based on the duration type
	note_duration = calculate_note_duration(duration_type)

	# Play the next note
	play_note_by_key(key)
	
	# Set the start time for the current note
	note_start_time = Time.get_ticks_msec()

func calculate_note_duration(duration_type: int) -> float:
	# Calculate the duration of the note based on its type, in milliseconds
	match duration_type:
		1:
			return beat_interval * 4.0  # Whole note
		2:
			return beat_interval * 2.0  # Half note
		3:
			return beat_interval * 1.0  # Quarter note
		4:
			return beat_interval * 0.5  # Eighth note
		5:
			return beat_interval * 0.25  # Sixteenth note
		_:
			return beat_interval * 1.0  # Default to quarter note if unknown

func play_note_by_key(key: String):
	# Pause all currently playing notes before playing the next one
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
	pattern_start_time = Time.get_ticks_msec()  # Start the new pattern's timing
	play_next_note()  # Start the first note in the new pattern

func reset_pattern():
	# Reset the current pattern
	current_pattern = null
	current_note_index = 0
