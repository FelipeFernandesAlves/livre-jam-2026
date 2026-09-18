class_name TweenVisibilityTrigger
extends TweenTrigger

func _on_ready():
	if (!target.is_connected("visibility_changed", _on_target_visibility_changed)):
		target.connect("visibility_changed", _on_target_visibility_changed)
	
func _on_target_visibility_changed():
	if (!tweener is AutoTween):
		return

	if (tweener._ignore_visibility_change):
		return

	if (tweener.change_visibility):
		if (target.get("visible")):
			trigger_start()
		else:
			trigger_end()
	else:
		if (tweener._is_hiding):
			trigger_start()
		else:
			trigger_end()
