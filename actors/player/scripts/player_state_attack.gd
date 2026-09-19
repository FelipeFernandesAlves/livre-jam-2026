class_name PlayerStateAttack
extends PlayerState

enum ATTACK_DIR {
	UP,
	DOWN,
	SIDES
}

@export var up_damageful: Damageful
@export var down_damageful: Damageful
@export var sides_damageful: Damageful

@onready var damageful_map = {
	ATTACK_DIR.UP:
		up_damageful,
	ATTACK_DIR.DOWN:
		down_damageful,
	ATTACK_DIR.SIDES:
		sides_damageful,
}

var damageful: Damageful

var current_attack_dir: ATTACK_DIR:
	set(value):
		current_attack_dir = value
		var input_component: InputComponent = player.input_component
		if (input_component.up_attack_pressed):
			current_attack_dir = ATTACK_DIR.UP
			animation_name = "attack_up"
		elif (input_component.down_attack_pressed):
			current_attack_dir = ATTACK_DIR.DOWN
			animation_name = "attack_down"
		else:
			current_attack_dir = ATTACK_DIR.SIDES
			animation_name = "attack"

var hitbox_position: Vector2
var looking_dir: float

var animation_name: String = "attack"

func _ready() -> void:
	super()
	hitbox_position = sides_damageful.position

func enter() -> void:
	damageful = damageful_map[current_attack_dir]
	damageful.reset_damage_registry()
	player.animator.play(animation_name)
	print(animation_name)
	player.movement_component.direction = Vector2.ZERO
	if (!player.animator.animation_finished.is_connected(_on_animation_finished)):
		player.animator.animation_finished.connect(_on_animation_finished)
	looking_dir = player.input_component.looking_direction

func physics_update(_delta: float) -> void:
	if (!player.is_on_floor()):
		player.movement_component.direction = Vector2(player.input_component.direction, 0)

	if (damageful == sides_damageful):
		if (looking_dir == 1):
			damageful.scale = Vector2(1.0, 1.0)
			damageful.position = hitbox_position
		else:
			damageful.scale = Vector2(-1.0, 1.0)
			damageful.position = Vector2(-hitbox_position.x, hitbox_position.y)

func exit() -> void:
	damageful.active = false

func _on_animation_finished(_animation_name: String):
	if (player.animator.animation_finished.is_connected(_on_animation_finished)):
		player.animator.animation_finished.disconnect(_on_animation_finished)
	transitioned.emit(self, "PlayerStateFree")
