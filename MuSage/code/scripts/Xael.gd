extends CharacterBody2D
@onready var animation_player = $Sprite2D/AnimationPlayer

# Speed in pixels/second
var speed = 200
var facing : String = ""

func _physics_process(_delta):
	# Setup direction of movement
	var direction = Input.get_vector("A", "D", "W", "S")
	
	# Stop diagonal movement by setting one axis to zero based on input
	if Input.is_action_pressed("D"):
		direction.y = 0

		animation_player.play("walk_right")
		facing = "right"
	elif Input.is_action_pressed("A"):
		direction.y = 0

		animation_player.play("walk_left")
		facing = "left"
	elif Input.is_action_pressed("S"):
		direction.x = 0

		animation_player.play("walk_down")
		facing = "down"
	elif Input.is_action_pressed("W"):
		direction.x = 0

		animation_player.play("walk_up")
		facing = "up"
	else:
		direction = Vector2.ZERO
		animation_player.stop()
		if facing == "left":
			$Sprite2D.frame = 3
		elif facing == "right":
			$Sprite2D.frame = 1
		elif facing == "up":
			$Sprite2D.frame = 2
		elif facing == "down":
			$Sprite2D.frame = 0
		
		


	# Normalize the directional movement
	direction = direction.normalized()

	# Setup the actual movement
	velocity = direction * speed
	move_and_slide()

