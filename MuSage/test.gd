extends CharacterBody2D

# Speed of the character
@export var speed = 200

func _physics_process(delta):
	var velocity = Vector2.ZERO  # Initialize velocity as zero

	# Handle input for movement and change sprite frame accordingly
	if Input.is_action_pressed("ui_right"):
		$Sprite2D.frame = 1
		velocity.x += 1

	elif Input.is_action_pressed("ui_down"):
		$Sprite2D.frame = 0
		velocity.y += 1
	
	elif Input.is_action_pressed("ui_left"):
		$Sprite2D.frame = 3
		velocity.x -= 1

	elif Input.is_action_pressed("ui_up"):
		$Sprite2D.frame = 2
		velocity.y -= 1

	# Normalize the velocity to avoid faster diagonal movement
	velocity = velocity.normalized() * speed
	
	# Move the character
	move_and_slide()
