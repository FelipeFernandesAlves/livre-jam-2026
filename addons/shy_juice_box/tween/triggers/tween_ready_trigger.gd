class_name TweenReadyTrigger
extends TweenTrigger

func _on_ready():
	target.ready.connect(trigger_start)
	await target.ready
	trigger_start()