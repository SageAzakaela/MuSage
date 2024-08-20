extends CharacterBody2D

@onready var animation_player = $Sprite2D/AnimationPlayer

# Export variable to assign the Player node in the editor
@export var player_node: NodePath
var player = null

@export var speed: int = 50  # Adjust speed as needed
var stop_distance = 32  # Distance in pixels where the slug will stop moving towards the player

func _ready():
	# Get the player node reference from the assigned node path
	if player_node:
		player = get_node(player_node)

func _process(delta):
	if player:
		follow_player(delta)

func follow_player(delta):
	var direction_to_player = (player.global_position - global_position).normalized()
	var distance_to_player = global_position.distance_to(player.global_position)

	# If the slug is far enough from the player, move towards them
	if distance_to_player > stop_distance:
		velocity = direction_to_player * speed
		move_and_slide()

		# Determine the appropriate animation based on direction
		if abs(direction_to_player.x) > abs(direction_to_player.y):
			if direction_to_player.x < 0:
				animation_player.play("move_left")
			else:
				animation_player.play("move_right")
		else:
			if direction_to_player.y < 0:
				animation_player.play("move_up")
			else:
				animation_player.play("move_down")
	else:
		# Stop moving and idle if within the stop distance
		velocity = Vector2.ZERO
		move_and_slide()
		animation_player.stop()

