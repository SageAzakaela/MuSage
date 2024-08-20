extends Node

@export var BPM : int = 120  # Beats per minute
@export var beat_display_duration : float = 0.75  # Percentage of the beat interval the indicator stays pink

@onready var guitar_player = $"../GuitarPlayer"
@onready var backing_track = $BackingTrack
@onready var effect_label = $"../EffectLabel"
@onready var enemy_health = $"../EnemyHealth"
@onready var player_health = $"../PlayerHealth"


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
	# Load all Pattern resources from the specified folder
	load_patterns_from_folder("res://resources/user_made_patterns/")
	
	# Calculate the beat interval (time between beats in seconds)
	beat_interval = 60.0 / BPM
	# Calculate how long the indicator should stay pink
	beat_active_duration = beat_interval * beat_display_duration
	$BackingTrack.play()
	#print("Ready: Beat interval calculated as ", beat_interval, " seconds per beat.")


func load_patterns_from_folder(folder_path: String):
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var pattern = load(folder_path + "/" + file_name)
				if pattern is Pattern:
					patterns.append(pattern)
					print(patterns)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open directory: " + folder_path)


func _process(delta):
	# Update the time since the last beat
	time_since_last_beat += delta

	# Reset the timer after each beat interval
	if time_since_last_beat >= beat_interval:
		time_since_last_beat -= beat_interval

	# Handle key input detection
	_handle_input()
	update_displayed_sequence()
	check_patterns()
		
func _handle_input():
	var time_now = Time.get_ticks_msec()  # Get the current time in milliseconds
	var keys = ["A", "S", "D", "F", "J", "K", "L", ";", "Q", "W", "E", "R", "U", "I", "O", "P"]
	
	for key in keys:
		if Input.is_action_just_pressed(key):
			# Record the key and the time it was pressed
			key_press_times[key] = time_now  # Initialize the press time
			print("Input: Key pressed - ", key, " at time ", time_now)

		if Input.is_action_just_released(key):
			if key in key_press_times:
				# Calculate the duration the key was held
				var input_duration = (time_now - key_press_times[key]) / 1000.0  # Convert ms to seconds
				input_sequence.append({"key": key, "start_time": key_press_times[key], "end_time": time_now, "duration_type": calculate_duration_type(input_duration)})
				print("Input: Key released - ", key, " with duration ", input_duration, " resulting in type ", input_sequence[-1]["duration_type"])
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
	
func update_displayed_sequence():
	# Update the score label to show the executed notes
	var displayed_sequence = ""
	for note_info in input_sequence:
		displayed_sequence += note_info["key"] + note_info["duration_type"] + " "
	#print("Displayed Sequence: ", displayed_sequence.strip_edges())
	$"../ScoreLabel4".text = displayed_sequence.strip_edges()

	
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

					# Update the magic effect label
					if pattern.EffectName != "":
						effect_label.text = pattern.EffectName
					else:
						effect_label.text = ""
					if pattern.EffectDescription != "":
						$"../EffectDescription".text = pattern.EffectDescription
					else:
						$"../EffectDescription".text = ""
					
					if pattern.EnemyHealthAdjustment != 0:
						enemy_health.value -= pattern.EnemyHealthAdjustment
					if pattern.PlayerHealthAdjustment != 0:
						player_health.value += pattern.PlayerHealthAdjustment
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
