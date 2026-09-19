class_name ArenaUI
extends Control

@export var health_label: Label
@export var color_rect: ColorRect

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.health_component.health_changed.connect(_on_player_health_changed)
	_on_player_health_changed(player.health_component.health)

	player.health_component.died.connect(func():
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
		SceneManager.instance.restart_node2D_scene()
		tween.finished.connect(func():
			get_tree().paused = false
			)
		get_tree().paused = true
	)

func _on_player_health_changed(new_value: float):
	health_label.text = str(round(new_value))