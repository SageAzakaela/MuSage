extends Node

@export var BPM : int = 120  # Beats per minute
@export var beat_display_duration : float = 0.75  # Percentage of the beat interval the indicator stays pink

@onready var guitar_player = $"../GuitarPlayer"
@onready var beat_indicator = $"../beat_indicator"
@onready var backing_track = $BackingTrack
@onready var score_label = $"../ScoreLabel"

# Variables to track beat timing
var beat_interval = 0.0
var time_since_last_beat = 0.0
var beat_active_duration = 0.0

# Score variable
var score = 0

# Patterns to check against
@export var patterns: Array[Pattern] = []

# Track input sequence
var input_sequence = []

func _ready():
	# Calculate the beat interval (time between beats in seconds)
	beat_interval = 60.0 / (BPM )
	# Calculate how long the indicator should stay pink
	beat_active_duration = beat_interval * beat_display_duration
	$BackingTrack.play()

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
	$"../ScoreLabel4".text = str(input_sequence)

func _input(event):
	# Map input events to their corresponding key strings
	var key = ""
	if event.is_action_pressed("A"):
		key = "A"
	elif event.is_action_pressed("S"):
		key = "S"
	elif event.is_action_pressed("D"):
		key = "D"
	elif event.is_action_pressed("F"):
		key = "F"
	elif event.is_action_pressed("J"):
		key = "J"
	elif event.is_action_pressed("K"):
		key = "K"
	elif event.is_action_pressed("L"):
		key = "L"
	elif event.is_action_pressed(";"):
		key = ";"
	elif event.is_action_pressed("Q"):
		key = "Q"
	elif event.is_action_pressed("W"):
		key = "W"
	elif event.is_action_pressed("E"):
		key = "E"
	elif event.is_action_pressed("R"):
		key = "R"
	elif event.is_action_pressed("U"):
		key = "U"
	elif event.is_action_pressed("I"):
		key = "I"
	elif event.is_action_pressed("O"):
		key = "O"
	elif event.is_action_pressed("P"):
		key = "P"

	# If a key was pressed and it is within the beat window
	if key != "" and time_since_last_beat <= beat_active_duration:
		# Add the key to the input sequence
		input_sequence.append(key)
		# Check if the sequence matches any of the target patterns
		_check_patterns()
		# Increment the score for valid input
		score += 1
		# Update the score label
		score_label.text = "Score: " + str(score)

func _check_patterns():
	for pattern in patterns:
		if len(input_sequence) >= len(pattern.Sequence):
			# Compare the input sequence to the current pattern's sequence
			var pattern_matched = true
			for i in range(len(pattern.Sequence)):
				if input_sequence[len(input_sequence) - len(pattern.Sequence) + i] != pattern.Sequence[i]:
					pattern_matched = false
					break
			
			if pattern_matched:
				# If they match, award the pattern points and reset the input sequence
				score += pattern.Points
				score_label.text = "Score: " + str(score)
				# Clear the sequence to start fresh
				input_sequence.clear()
				# Since a pattern was matched, break out of the loop to avoid checking further patterns
				break
			else:
				# If the sequence doesn't match, keep only the most recent inputs that are as long as the longest pattern
				input_sequence = input_sequence.slice(-len(pattern.Sequence))
