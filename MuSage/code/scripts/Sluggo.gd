extends CharacterBody2D

@onready var animation_player = $Sprite2D/AnimationPlayer

var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
var current_direction = Vector2.ZERO
var change_direction_timer = 0.0
var time_to_change_direction = 6.0  # Change direction every 2 seconds (you can adjust this)
@export var speed: int = 50  # Adjust speed as needed

func _ready():
	# Set an initial random direction
	change_direction()

func _process(delta):
	# Move the NPC in the current direction
	velocity = current_direction * speed
	move_and_slide()

	# Decrease the timer
	change_direction_timer -= delta

	# If it's time to change direction, pick a new random direction
	if change_direction_timer <= 0:
		change_direction()

func change_direction():
	# Pick a random direction from the list
	current_direction = directions[randi() % directions.size()]

	# Set the appropriate animation
	if current_direction == Vector2.LEFT:
		animation_player.play("move_left")
	elif current_direction == Vector2.RIGHT:
		animation_player.play("move_right")
	elif current_direction == Vector2.UP:
		animation_player.play("move_up")
	elif current_direction == Vector2.DOWN:
		animation_player.play("move_down")

	# Reset the timer for the next change
	change_direction_timer = time_to_change_direction


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
