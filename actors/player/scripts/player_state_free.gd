class_name PlayerStateFree
extends PlayerState

@export var player_dash_cooldown: float = 0.25
var dash_timer: float = 0.0
var can_dash: bool = true

@export var attack_state: PlayerStateAttack
@export var player_attack_cooldown: float = 0.5
var attack_timer: float = 0.0
var can_attack: bool = true

func enter() -> void:
	player.movement_component.speed = player.WALK_VELOCITY
	player.movement_component.can_apply_gravity = true
	player.movement_component.use_speed_modifier = true
	player.sprites.material.set_shader_parameter("active", false)

func physics_update(delta: float) -> void:
	player.movement_component.direction = Vector2(player.input_component.direction, 0)
	player.movement_component.wants_jump = player.input_component.jump_pressed

	update_dash_cooldown(delta)
	update_attack_cooldown(delta)
	player.sprites.flip_h = player.input_component.looking_direction

	handle_animation()
	handle_attack()

	if (player.input_component.dash_pressed && can_dash):
		transitioned.emit(self, "PlayerStateDash")
		can_dash = false

func update_dash_cooldown(delta: float):
	if (can_dash):
		return

	dash_timer += delta
	if (dash_timer >= player_dash_cooldown):
		can_dash = true
		dash_timer = 0.0

func update_attack_cooldown(delta: float):
	if (can_attack):
		return

	attack_timer += delta
	if (attack_timer >= player_attack_cooldown):
		can_attack = true
		attack_timer = 0.0

func handle_animation():
	var animation: String = "idle"
	if (player.animator.current_animation != animation):
		player.animator.play("RESET")
		player.animator.play()

func handle_attack():
	if (!can_attack):
		return

	var attack_dir: PlayerStateAttack.ATTACK_DIR

	if (player.input_component.up_attack_pressed):
		attack_dir = PlayerStateAttack.ATTACK_DIR.UP
	elif (player.input_component.down_attack_pressed):
		attack_dir = PlayerStateAttack.ATTACK_DIR.DOWN
	elif (player.input_component.attack_pressed):
		attack_dir = PlayerStateAttack.ATTACK_DIR.SIDES
	else:
		return

	attack_state.current_attack_dir = attack_dir
	transitioned.emit(self, "PlayerStateAttack")
	can_attack = false
