class_name Camera
extends Camera2D

enum CameraModes {
	TARGET,
	ANCHOR
}

const TARGET = CameraModes.ANCHOR
const ANCHOR = CameraModes.TARGET

@export var target: Node2D
@export var camera_bounds: CollisionShape2D
@export var anchor: Node
@export var camera_mode: CameraModes = CameraModes.ANCHOR

# Screeen shake
var shake_intensity: float = 0.0
var active_shake_time: float = 0.0
var shake_decay: float = 2.0
var shake_time: float = 0.0
var shake_time_speed: float = 20.0

var noise = FastNoiseLite.new()

func _ready() -> void:
	# Camera bound to area
	if (camera_bounds && camera_bounds.shape is RectangleShape2D):
		var rect: RectangleShape2D = camera_bounds.shape
		var extents: Vector2 = rect.extents
		var global_pos: Vector2 = camera_bounds.global_position

		limit_left = int(global_pos.x - extents.x)
		limit_top = int(global_pos.y - extents.y)
		limit_right = int(global_pos.x + extents.x)
		limit_bottom = int(global_pos.y + extents.y)

func _process(_delta: float) -> void:
	# Follow target
	match camera_mode:
		CameraModes.TARGET:
			if (target != null):
				global_position = target.global_position
		CameraModes.ANCHOR:
			if (anchor):
				global_position = anchor.global_position

func _physics_process(delta: float) -> void:
	# Screen shake
	if (active_shake_time > 0):
		shake_time += delta * shake_time_speed
		active_shake_time -= delta

		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)

		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func screen_shake(intensity: int, time: float):
	noise.seed = randi()
	noise.frequency = 2.0

	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0

