@abstract
class_name State extends Node

var can_physics_update: bool = true
var can_update: bool = true

@warning_ignore("unused_signal")
signal transitioned(state: State, new_state_name: String)

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func update(_delta: float) -> void:
	pass