class_name InputComponent
extends Node

var looking_direction: float

var direction: float
var jump_pressed: bool
var dash_pressed: bool

var attack_pressed: bool
var down_attack_pressed: bool
var up_attack_pressed: bool

func _process(_delta: float) -> void:
	jump_pressed = Input.is_action_just_pressed("move_jump")
	dash_pressed = Input.is_action_just_pressed("move_dash")
	direction = Input.get_axis("move_left", "move_right")

	up_attack_pressed = false
	down_attack_pressed = false
	attack_pressed = false

	if (Input.is_action_just_pressed("attack")):
		if (Input.is_action_pressed("move_up")):
			up_attack_pressed = true
		elif (Input.is_action_pressed("move_down")):
			down_attack_pressed = true
		else:
			attack_pressed = true

	if (direction):
		looking_direction = direction