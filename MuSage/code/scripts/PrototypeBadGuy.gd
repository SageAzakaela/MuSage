extends Node

@export var BPM: int = 120  # Beats per minute
@onready var effect_label = $"../EffectLabel"
@onready var player_health = $"../PlayerHealth"

# Variables to track beat timing
var beat_interval = 0.0
var time_since_last_beat = 0.0
var beats_elapsed = 0

# List of possible enemy attacks
var enemy_attacks = [
	{"name": "Enemy used Slash", "damage": -10},
	{"name": "Enemy used Fireball", "damage": -15},
	{"name": "Enemy used Poison Dart", "damage": -8},
	{"name": "Enemy used Shockwave", "damage": -12},
	{"name": "Enemy used Dark Pulse", "damage": -20}
]

func _ready():
	# Calculate the beat interval (time between beats in seconds)
	beat_interval = 60.0 / BPM

func _process(delta):
	# Update the time since the last beat
	time_since_last_beat += delta

	# Reset the timer after each beat interval and count the beats
	if time_since_last_beat >= beat_interval:
		time_since_last_beat -= beat_interval
		beats_elapsed += 1

		# Check if 8 beats have passed
		if beats_elapsed >= 8:
			perform_enemy_attack()
			beats_elapsed = 0  # Reset the beat counter

func perform_enemy_attack():
	# Choose a random attack
	var attack = enemy_attacks[randi() % enemy_attacks.size()]

	# Update the effect label to show the name of the attack
	effect_label.text = attack["name"]

	# Adjust the player's health
	player_health.value += attack["damage"]
