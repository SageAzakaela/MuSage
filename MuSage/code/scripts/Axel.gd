extends CharacterBody2D

@onready var animation_player = $Sprite2D/AnimationPlayer

@export var Stationary = true  # If true, the NPC will stay in place and face the player
@export var wander_radius = 100  # The radius within which the NPC can wander if Stationary is false
@export var player_node: NodePath  # Assign the player node here in the editor

var speed = 150  # Speed in pixels/second
var facing : String = ""
var initial_position : Vector2  # Store the initial position for wandering
var player = null

func _ready():
	initial_position = global_position  # Save the starting position for wandering
	if player_node:
		player = get_node(player_node)

func _physics_process(_delta):
	if Stationary:
		if player:
			face_player()
	else:
		wander()

func face_player():
	if not player:
		return

	# Determine the direction to the player
	var direction_to_player = (player.global_position - global_position).normalized()

	if abs(direction_to_player.x) > abs(direction_to_player.y):
		if direction_to_player.x < 0:
			facing = "left"

		else:
			facing = "right"

	else:
		if direction_to_player.y < 0:
			facing = "up"

		else:
			facing = "down"

	if facing == "left":		$Sprite2D.frame = 3
	elif facing == "right":
		$Sprite2D.frame = 1
	elif facing == "up":
		$Sprite2D.frame = 2
	elif facing == "down":
		$Sprite2D.frame = 0


	# Stop the animation since the NPC is stationary
	animation_player.stop()

func wander():
	# Setup direction of movement
	var direction = Vector2.ZERO

	# Random chance to change direction
	if randi() % 100 < 5:
		direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()

	# Ensure direction doesn't get reset if it's zero
	if direction == Vector2.ZERO and velocity != Vector2.ZERO:
		direction = velocity.normalized()
	
	# Move within the wander radius
	if global_position.distance_to(initial_position) > wander_radius:
		direction = (initial_position - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

	# Set the appropriate animation based on direction
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x < 0:
				animation_player.play("walk_left")
				facing = "left"
			else:
				animation_player.play("walk_right")
				facing = "right"
		else:
			if direction.y < 0:
				animation_player.play("walk_up")
				facing = "up"
			else:
				animation_player.play("walk_down")
				facing = "down"
	else:
		animation_player.stop()
		# Set the idle frame
		if facing == "left":
			$Sprite2D.frame = 3
		elif facing == "right":
			$Sprite2D.frame = 1
		elif facing == "up":
			$Sprite2D.frame = 2
		elif facing == "down":
			$Sprite2D.frame = 0
