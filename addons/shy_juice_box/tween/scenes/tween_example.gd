extends CanvasLayer

@export var demo_button: Button
@export var auto_tween: AutoTween

func _on_check_button_toggled(toggled_on: bool) -> void:
	demo_button.visible = toggled_on

func _on_show_hide_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		auto_tween.start_tween()
	else:
		auto_tween.end_tween()
