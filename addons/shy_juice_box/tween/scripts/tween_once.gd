class_name TweenOnce
extends CustomTweener

@export var interval: float

signal once_in_started()
signal once_in_ended()

signal once_out_started()
signal once_out_ended()

func once_in(event: TweenEvent):
	if (!active):
		return

	once_in_started.emit()

	var _tween: Tween = event.tween

	for animation: TweenAnimation in tweener_properties.animations:
		_tween.parallel()
		animation.once_in(event)
		
	_tween.tween_callback(_once_in_ended)

func _once_in_ended():
	once_in_ended.emit()

func once_out(event: TweenEvent):
	if (!active):
		return

	once_out_started.emit()
	var _tween: Tween = event.tween

	for animation: TweenAnimation in tweener_properties.animations:
		_tween.parallel()
		animation.once_out(event)
		
	_tween.tween_callback(_once_out_ended)

func _once_out_ended():
	once_in_ended.emit()