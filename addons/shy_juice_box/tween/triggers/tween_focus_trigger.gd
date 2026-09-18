class_name TweenFocusTrigger
extends TweenTrigger

func _on_ready():
	if (!target is Control):
		push_warning("TweenFocusTrigger only works with Control target Nodes.")
		return

	if (!target.is_connected("focus_entered", trigger_start)):
		target.focus_entered.connect(trigger_start)
	
	if (!target.is_connected("focus_exited", trigger_end)):
		target.focus_exited.connect(trigger_end)