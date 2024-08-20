extends Area2D
@onready var question_mark = $QuestionMark

@export var timeline : String = ""
var in_range : bool = false
var dialogue_exhausted : bool = false


func _on_body_entered(body):
	if body.is_in_group("Player") and dialogue_exhausted == false:
		in_range = true
		question_mark.visible = true

func _process(_delta):
	if in_range == true:
		get_input()
		

func get_input():
	if Input.is_action_just_pressed("ui_accept") and dialogue_exhausted == false:
		dialogue_exhausted = true	
		Dialogic.start(timeline)

func _on_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
		question_mark.visible = false
