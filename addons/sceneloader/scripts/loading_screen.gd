@abstract
class_name LoadingScreen
extends CanvasLayer

signal loading_screen_ready()
var transition_name: String

func _on_progress_changed(new_value: float):
	pass

func _on_load_finished():
	pass