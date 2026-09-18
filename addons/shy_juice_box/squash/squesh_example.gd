extends Node2D

@export var squesh: Squesh

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_left")):
		squesh.squash()

	elif (event.is_action_pressed("ui_right")):
		squesh.stretch()

	elif (event.is_action_pressed("ui_up")):
		squesh.squash_and_stretch()

	elif (event.is_action_pressed("ui_down")):
		squesh.stretch_and_squash()
