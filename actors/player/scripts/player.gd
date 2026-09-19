class_name Player
extends CharacterBody2D

@export var sprites: AnimatedSprite2D
@export var animator: AnimationPlayer
@export var squesh: Squesh

@export var state_machine: StateMachine
@export var damageable: Damageable
@export var attack_state: PlayerStateAttack
@export var hurt_state: PlayerStateHurt

@export var up_damageful: Damageful
@export var down_damageful: Damageful
@export var attack_damageful: Damageful

@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var health_component: HealthComponent

@onready var camera: Camera

const WALK_VELOCITY: float = 250.0
const ATTACK_DAMAGE: float = 10.0

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	movement_component.jumped.connect(squesh.squash)
	movement_component.landed.connect(squesh.squash)

	up_damageful.damaged.connect(_on_attack_damaged)
	down_damageful.damaged.connect(_on_attack_damaged)
	attack_damageful.damaged.connect(_on_attack_damaged)

	attack_damageful.add_exception(self)
	up_damageful.add_exception(self)
	down_damageful.add_exception(self)

	damageable.damaged.connect(_on_damage_received)

func _on_damage_received(body: Damageful):
	if (damageable.can_take_damage):
		hurt_state.body = body
		state_machine.change_state("PlayerStateHurt")

func _on_attack_damaged(body: Damageable):
	var other_health_component: HealthComponent = body.get_parent().get("health_component")
	if (other_health_component):
		other_health_component.take_damage(ATTACK_DAMAGE)
	
	# POGO
	if (attack_state.current_attack_dir == PlayerStateAttack.ATTACK_DIR.DOWN):
		movement_component.pogo()
