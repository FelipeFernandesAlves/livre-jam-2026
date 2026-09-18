class_name AutoTween
extends CustomTweener

@export var change_visibility: bool = false
@export var free_on_hide: bool = false

var _ignore_visibility_change: bool = false
var _is_hiding: bool

signal show_started()
signal show_ended()

signal hide_started()
signal hide_ended()

func start_tween():
	var tween := create_tween()
	var event := TweenEvent.new(tween, self)
	show(event)

func end_tween():
	var tween := create_tween()
	var event := TweenEvent.new(tween, self)
	hide(event)

func show(event: TweenEvent):
	if (!active):
		return

	show_started.emit()

	_ignore_visibility_change = true
	if (change_visibility):
		target.set("visible", true)

	_is_hiding = false
	_ignore_visibility_change = false

	var _tween: Tween = event.tween
	if (!_tween || !_tween.is_valid()):
		return

	if (tweener_properties.start_delay > 0.0):
		_tween.tween_interval(tweener_properties.start_delay)
	
	for animation: TweenAnimation in tweener_properties.animations:
		_tween.parallel()
		animation.show(event)

	_tween.tween_callback(_show_ended)

func _show_ended():
	show_ended.emit()

func hide(event: TweenEvent):
	if (!active):
		return

	hide_started.emit()
	if (change_visibility):
		_ignore_visibility_change = true
		target.set("visible", true)

	_is_hiding = true

	var _tween: Tween = event.tween
	if (!_tween || !_tween.is_valid()):
		return

	for animation: TweenAnimation in tweener_properties.animations:
		_tween.parallel()
		animation.hide(event)
		
	_tween.tween_callback(_hide_ended)

func _hide_ended():
	hide_ended.emit()
	
	if (change_visibility):
		target.set("visible", false)
		
	_ignore_visibility_change = false

	if (free_on_hide):
		target.queue_free()
		queue_free()