extends CharacterBody2D

@export var health_label: Label
@export var health_component: HealthComponent

func _ready() -> void:
	health_component.health_changed.connect(_on_player_health_changed)
	_on_player_health_changed(health_component.health)

func _on_player_health_changed(new_value: float):
	health_label.text = str(round(new_value))