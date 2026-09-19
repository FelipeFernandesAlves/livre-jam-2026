class_name Damageful extends Area2D

@export var one_time_damage: bool
@export var active: bool

var already_damaged: Array[Node2D]
var damage_exceptions: Array[Node2D]

var inside_bodies: Array[Node2D]

signal damaged(body: Damageable)

func _ready() -> void:
	area_entered.connect(_on_collision_area_entered)
	area_exited.connect(_on_collision_area_exited)

func _physics_process(_delta: float) -> void:
	if (!active):
		return

	for body in inside_bodies:
		if (!(body is Damageable && body.can_take_damage)):
			continue
		
		if (one_time_damage && (body in already_damaged || body.get_parent() in already_damaged)):
			continue
		
		if (body in damage_exceptions || body.get_parent() in damage_exceptions):
			continue
		
		if (!body in already_damaged):
			already_damaged.append(body)

		body.damaged.emit(self)
		self.damaged.emit(body)

func _on_collision_area_entered(body: Area2D):
	if (body is Damageable):
		inside_bodies.append(body)

func _on_collision_area_exited(body: Area2D):
	if (body in inside_bodies):
		inside_bodies.remove_at(inside_bodies.find(body))

func add_exception(body: Node2D):
	if (body):
		damage_exceptions.append(body)

func reset_exceptions():
	damage_exceptions.clear()

func reset_damage_registry():
	already_damaged.clear()
