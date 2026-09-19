class_name HealthComponent
extends Node

@export var max_health: float
@onready var _health: float = max_health:
	set(value):
		_health = value
		health_changed.emit(_health)

var health:
	get(): return _health
	set(value): return
	
var dead: bool = false

signal died()
signal health_changed(new_value: float)

func take_damage(value: float):
	_health = clamp(_health - value, 0.0, max_health)
	if (_health <= 0.0):
		died.emit()
		dead = true

func heal(value: float):
	_health = clamp(_health + value, 0.0, max_health)