extends Node

@export var pattern_save_path : String = "res://resources/user_made_patterns/"

var is_recording = false
var recorded_sequence = []

# Dictionary to keep track of key press times
var key_press_times = {}

func _ready():
	print("Pattern Recorder ready. Press Space to start/stop recording.")

func _process(delta):
	# Start/Stop recording on spacebar press (mapped to ui_select by default)
	if Input.is_action_just_pressed("ui_select"):  
		if is_recording:
			_stop_recording()
		else:
			_start_recording()

	# Handle input for recording while in _process
	_handle_input()

func _start_recording():
	is_recording = true
	recorded_sequence.clear()
	key_press_times.clear()
	print("Recording started.")

func _stop_recording():
	is_recording = false
	print("Recording stopped.")
	_save_pattern()

func _handle_input():
	if is_recording:
		for action in ["A", "S", "D", "F", "J", "K", "L", ";", "Q", "W", "E", "R", "U", "I", "O", "P"]:
			if Input.is_action_just_pressed(action):
				var time_now = Time.get_ticks_msec()
				key_press_times[action] = time_now
				recorded_sequence.append({"key": action, "start_time": time_now, "end_time": -1})
				print("Key pressed: ", action, " at time: ", time_now)
			
			elif Input.is_action_just_released(action):
				if action in key_press_times:
					var time_now = Time.get_ticks_msec()
					for note in recorded_sequence:
						if note["key"] == action and note["end_time"] == -1:
							note["end_time"] = time_now
							note["duration_type"] = _calculate_duration_type((time_now - note["start_time"]) / 1000.0)
							break
					key_press_times.erase(action)


func _calculate_duration_type(duration):
	print("Calculating duration type for duration: ", duration, " seconds")

	# You can adjust the thresholds based on your beat_interval or other criteria
	var whole_note_threshold = 2.0  # 2 seconds for example
	var half_note_threshold = 1.0
	var quarter_note_threshold = 0.5
	var eighth_note_threshold = 0.25

	if duration >= whole_note_threshold:
		return "1"  # Whole note
	elif duration >= half_note_threshold:
		return "2"  # Half note
	elif duration >= quarter_note_threshold:
		return "3"  # Quarter note
	elif duration >= eighth_note_threshold:
		return "4"  # Eighth note
	else:
		return "5"  # Sixteenth note or shorter

func _save_pattern():
	var pattern_resource = Pattern.new()
	var sequence: Array[String] = []  # Explicitly declare this as an Array[String]
	
	for note in recorded_sequence:
		sequence.append(note["key"] + note["duration_type"])

	# Assign the sequence to the Pattern resource
	pattern_resource.Sequence = sequence
	pattern_resource.Points = recorded_sequence.size() * 10  # Example: 10 points per note

	var save_path = pattern_save_path + "user_pattern_" + str(Time.get_ticks_msec()) + ".tres"
	
	# The correct function call in Godot 4.2
	var save_result = ResourceSaver.save(pattern_resource, save_path)
	
	if save_result == OK:
		print("Pattern saved to:", save_path)
	else:
		print("Failed to save pattern:", save_result)




