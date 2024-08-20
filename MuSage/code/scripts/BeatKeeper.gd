extends Node

@export var BPM : int = 120  # Beats per minute
@export var beat_display_duration : float = 0.75  # Percentage of the beat interval the indicator stays pink

@onready var guitar_player = $"../GuitarPlayer"
@onready var beat_indicator = $"../beat_indicator"
@onready var backing_track = $BackingTrack
@onready var score_label = $"../ScoreLabel"
@onready var magic_effect = $"../MagicEffect"

# Variables to track beat timing
var beat_interval = 0.0
var time_since_last_beat = 0.0
var beat_active_duration = 0.0

# Score variable
var score = 0

# Patterns to check against
@export var patterns: Array[Pattern] = []

# Track input sequence with timestamps
var input_sequence = []

# Dictionary to keep track of key press times
var key_press_times = {}

func _ready():
	# Calculate the beat interval (time between beats in seconds)
	beat_interval = 60.0 / BPM
	# Calculate how long the indicator should stay pink
	beat_active_duration = beat_interval * beat_display_duration
	$BackingTrack.play()
	#print("Ready: Beat interval calculated as ", beat_interval, " seconds per beat.")

func _process(delta):
	# Update the time since the last beat
	time_since_last_beat += delta

	# Check if it's time to indicate a beat
	if time_since_last_beat <= beat_active_duration:
		# Change color to indicate a beat
		beat_indicator.color = Color(0.75, 0, 0.75)  # Pink color
	else:
		# Change color back when not on beat
		beat_indicator.color = Color(0, 0, 0.75)  # Blue color

	# Reset the timer after each beat interval
	if time_since_last_beat >= beat_interval:
		time_since_last_beat -= beat_interval

	# Update the score label
	score_label.text = "Score: " + str(score)

	# Handle key input detection
	_handle_input()

	# Update the displayed sequence for debugging
	update_displayed_sequence()
	show_magic_name()

func _handle_input():
	var time_now = Time.get_ticks_msec()  # Get the current time in milliseconds
	var keys = ["A", "S", "D", "F", "J", "K", "L", ";", "Q", "W", "E", "R", "U", "I", "O", "P"]
	
	for key in keys:
		if Input.is_action_just_pressed(key):
			# Record the key and the time it was pressed
			key_press_times[key] = time_now  # Initialize the press time
			#print("Input: Key pressed - ", key, " at time ", time_now)

		if Input.is_action_just_released(key):
			if key in key_press_times:
				# Calculate the duration the key was held
				var input_duration = (time_now - key_press_times[key]) / 1000.0  # Convert ms to seconds
				input_sequence.append({"key": key, "start_time": key_press_times[key], "end_time": time_now, "duration_type": calculate_duration_type(input_duration)})
				#print("Input: Key released - ", key, " with duration ", input_duration, " resulting in type ", input_sequence[-1]["duration_type"])
				key_press_times.erase(key)

func calculate_duration_type(duration):
	#print("Calculating duration type for duration: ", duration, " seconds (Expected beat interval: ", beat_interval, " seconds)")

	# Calculate the thresholds for different note durations
	var whole_note_threshold = beat_interval * 4.0
	var half_note_threshold = beat_interval * 2.0
	var quarter_note_threshold = beat_interval * 1.0
	var eighth_note_threshold = beat_interval * 0.5
	var sixteenth_note_threshold = beat_interval * 0.25

	# Introduce a slight tolerance to each threshold
	var tolerance = beat_interval * 0.1  # 10% of the beat interval

	# Determine note type based on the calculated duration with tolerance
	if duration >= whole_note_threshold - tolerance:
		#print("Duration type is Whole Note (1)")
		return "1"  # Whole note
	elif duration >= half_note_threshold - tolerance:
		#print("Duration type is Half Note (2)")
		return "2"  # Half note
	elif duration >= quarter_note_threshold - tolerance:
		#print("Duration type is Quarter Note (3)")
		return "3"  # Quarter note
	elif duration >= eighth_note_threshold - tolerance:
		#print("Duration type is Eighth Note (4)")
		return "4"  # Eighth note
	else:
		#print("Duration type is Sixteenth Note (5)")
		return "5"  # Sixteenth note

func update_displayed_sequence():
	# Update the score label to show the executed notes
	var displayed_sequence = ""
	for note_info in input_sequence:
		displayed_sequence += note_info["key"] + note_info["duration_type"] + " "
	#print("Displayed Sequence: ", displayed_sequence.strip_edges())
	score_label.text = "Score: " + str(score)
	$"../ScoreLabel4".text = displayed_sequence.strip_edges()
	check_patterns()

func get_key_from_event(event):
	# Determine which key was pressed or released
	if event.is_action("A"):
		return "A"
	elif event.is_action("S"):
		return "S"
	elif event.is_action("D"):
		return "D"
	elif event.is_action("F"):
		return "F"
	elif event.is_action("J"):
		return "J"
	elif event.is_action("K"):
		return "K"
	elif event.is_action("L"):
		return "L"
	elif event.is_action(";"):
		return ";"
	elif event.is_action("Q"):
		return "Q"
	elif event.is_action("W"):
		return "W"
	elif event.is_action("E"):
		return "E"
	elif event.is_action("R"):
		return "R"
	elif event.is_action("U"):
		return "U"
	elif event.is_action("I"):
		return "I"
	elif event.is_action("O"):
		return "O"
	elif event.is_action("P"):
		return "P"
	return ""

func check_patterns():
	for pattern in patterns:
		if len(input_sequence) >= len(pattern.Sequence):
			# Allow the pattern to match anywhere within the input sequence
			for offset in range(len(input_sequence) - len(pattern.Sequence) + 1):
				var pattern_matched = true
				
				for i in range(len(pattern.Sequence)):
					var input_note = input_sequence[offset + i]
					var pattern_note = pattern.Sequence[i]

					# Combine key and duration type into a single string
					var combined_input = input_note["key"] + input_note["duration_type"]

					if combined_input != pattern_note:
						pattern_matched = false
						break

				if pattern_matched:
					# If they match, award the pattern points and reset the input sequence
					score += pattern.Points
					score_label.text = "Score: " + str(score)

					# Update the magic effect label
					if pattern.EffectName != "":
						magic_effect.text = "Effect: " + pattern.EffectName
					else:
						magic_effect.text = ""

					# Clear the sequence to start fresh
					input_sequence.clear()

					# Since a pattern was matched, break out of the loop to avoid checking further patterns
					return  # Exit early if a pattern is matched
	
	# After checking all patterns, only truncate input_sequence if necessary
	var max_pattern_length = 32
	for pattern in patterns:
		if len(pattern.Sequence) > max_pattern_length:
			max_pattern_length = len(pattern.Sequence)
	
	if len(input_sequence) > max_pattern_length:
		input_sequence = input_sequence.slice(-max_pattern_length)


func show_magic_name():
	var note_names = {
		"A": "Axion", "S": "Siron", "D": "Drox", "F": "Feron",
		"J": "Jyn", "K": "Kyron", "L": "Lunor", ";": "Syndra",
		"Q": "Quorion", "W": "Wyrn", "E": "Eldrox", "R": "Raelon",
		"U": "Ulyss", "I": "Iryon", "O": "Orlun", "P": "Pyra"
	}

	var duration_names = {
		"1": "Solum",    # Whole Note
		"2": "Dimora",   # Half Note
		"3": "Corta",    # Quarter Note
		"4": "Brevio",   # Eighth Note
		"5": "Veloce"    # Sixteenth Note
	}

	var magic_name_display = ""

	for note_info in input_sequence:
		var note = note_info["key"]
		var duration_type = note_info["duration_type"]

		# Get the in-universe names for the note and duration
		var note_name = note_names.get(note, note)
		var duration_name = duration_names.get(duration_type, duration_type)

		# Combine the note name and duration name
		magic_name_display += note_name + " " + duration_name + " - "

	# Remove the last "-- " for a cleaner display
	magic_name_display = magic_name_display.strip_edges()

	# Display the magic name sequence
	$"../MagicNames".text = magic_name_display
