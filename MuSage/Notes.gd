extends GridContainer

@onready var q = $Q
@onready var w = $W
@onready var e = $E
@onready var r = $R
@onready var u = $U
@onready var i = $I
@onready var o = $O
@onready var p = $P
@onready var a = $A
@onready var s = $S
@onready var d = $D
@onready var f = $F
@onready var j = $J
@onready var k = $K
@onready var l = $L
@onready var semicolon = $Semicolon

func _process(_delta):
	if Input.is_action_just_pressed("Q"):
		q.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("Q"):
		q.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("W"):
		w.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("W"):
		w.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("E"):
		e.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("E"):
		e.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("R"):
		r.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("R"):
		r.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("U"):
		u.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("U"):
		u.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("I"):
		i.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("I"):
		i.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("O"):
		o.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("O"):
		o.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("P"):
		p.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("P"):
		p.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("A"):
		a.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("A"):
		a.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("S"):
		s.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("S"):
		s.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("D"):
		d.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("D"):
		d.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("F"):
		f.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("F"):
		f.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("J"):
		j.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("J"):
		j.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("K"):
		k.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("K"):
		k.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("L"):
		l.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released("L"):
		l.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed(";"):
		semicolon.modulate = Color(0.5, 0.5, 0.5)
	if Input.is_action_just_released(";"):
		semicolon.modulate = Color(1, 1, 1)
