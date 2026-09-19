class_name MovementComponent
extends Node

@export var body: CharacterBody2D
@export var can_move: bool = true
@export var can_apply_gravity: bool = true
@export var speed: float
@export var jump_velocity := 700.0
@export var gravity_multiplier := 1.5
@export var speed_change_modifier := 0.25

@onready var current_speed_change_modifier = speed_change_modifier
var use_speed_modifier: bool = true

var direction: Vector2
var current_direction: Vector2

var wants_jump: bool = false
var can_jump: bool

var last_in_on_floor: bool

@export var coyote_timer_limit := 0.1
var coyote_timer := 0.0

@export var jump_buffer_timer_limit := 0.5
var jump_buffer_timer

var has_pogo: bool

signal jumped()
signal landed()

func _ready() -> void:
	if (body):
		last_in_on_floor = body.is_on_floor()

func _physics_process(delta: float) -> void:
	if (!can_move || !body):
		return

	var is_on_floor = body.is_on_floor()

	if (is_on_floor != last_in_on_floor):
		if (!last_in_on_floor):
			landed.emit()
		last_in_on_floor = is_on_floor

	if (is_on_floor):
		coyote_timer = 0
		can_jump = true
		current_speed_change_modifier = speed_change_modifier
		has_pogo = false
	else:
		if (can_apply_gravity):
			body.velocity += body.get_gravity() * delta * gravity_multiplier
		
		if (!has_pogo):
			current_speed_change_modifier = speed_change_modifier / 10

		_coyote_time(delta)

	if (wants_jump && can_jump):
		body.velocity.y -= jump_velocity
		wants_jump = false
		can_jump = false
		jumped.emit()

	if (use_speed_modifier):
		current_direction.x = lerp(current_direction.x, direction.x, current_speed_change_modifier)
	else:
		current_direction.x = direction.x
		current_speed_change_modifier = speed_change_modifier

	body.velocity.x = current_direction.x * speed
	body.move_and_slide()

func _coyote_time(delta: float):
	coyote_timer += delta
	if (coyote_timer >= coyote_timer_limit):
		can_jump = false

func pogo():
	body.velocity.y = 0
	body.velocity.y -= jump_velocity/2
	current_speed_change_modifier = 0.5
	has_pogo = true
