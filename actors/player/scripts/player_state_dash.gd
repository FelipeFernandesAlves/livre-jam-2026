class_name PlayerStateDash
extends PlayerState

@export var dash_duration: float = 1.0
@export var dash_speed: float = 700
var direction: float

func enter() -> void:
	player.movement_component.can_apply_gravity = false
	player.movement_component.direction.x = player.input_component.looking_direction
	player.movement_component.speed = dash_speed
	player.movement_component.use_speed_modifier = false
	player.velocity.y = 0
	get_tree().create_timer(dash_duration).timeout.connect(_on_timer_end)

func _on_timer_end():
	transitioned.emit(self, "PlayerStateFree")

func physics_update(_delta: float) -> void:
	pass
