extends Label

var enabled = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and enabled == false:
		enabled = true
		text = "Recording Enabled"
	elif Input.is_action_just_pressed("ui_accept") and enabled == true:
		enabled = false
		text = "Recording Disabled"
