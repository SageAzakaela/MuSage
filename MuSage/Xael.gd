extends CharacterBody2D

# Speed in pixels/second
var speed = 150

func _physics_process(delta):
	# Setup direction of movement
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Stop diagonal movement by setting one axis to zero based on input
	if Input.is_action_pressed("ui_right"):
		direction.y = 0
		$Sprite2D.frame = 1  # Right frame

	elif Input.is_action_pressed("ui_left"):
		direction.y = 0
		$Sprite2D.frame = 3  # Left frame

	elif Input.is_action_pressed("ui_down"):
		direction.x = 0
		$Sprite2D.frame = 0  # Down frame

	elif Input.is_action_pressed("ui_up"):
		direction.x = 0
		$Sprite2D.frame = 2  # Up frame

	else:
		direction = Vector2.ZERO


	# Normalize the directional movement
	direction = direction.normalized()

	# Setup the actual movement
	velocity = direction * speed
	move_and_slide()

