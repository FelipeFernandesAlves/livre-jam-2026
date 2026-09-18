@abstract
class_name TweenTrigger
extends Node

@export_group("Custom Pointers")
@export var tweener: CustomTweener
@export var target: Node:
	set(value):
		target = value
		target_changed.emit()

var active: bool = true
var tween: Tween

signal target_changed()

func _ready() -> void:
	if (!tweener):
		tweener = get_parent()

	if (!target && tweener):
		target = tweener.target
	
	_on_ready()

func _on_ready():
	pass

func trigger_once():
	if (!active || !tweener.active || !tweener is TweenOnce):
		return

	if (tween && tween.is_valid()):
		tween.kill()

	tween = tweener.create_tween()
	var event = TweenEvent.new(tween, tweener)
	tweener.once_in(event)

	tween.finished.connect(func():
		if (tweener.interval > 0.0): 
			tween.tween_interval(tweener.interval)
	
		if (tween && tween.is_valid()):
			tween.kill()

		tween = tweener.create_tween()
		var _event = TweenEvent.new(tween, tweener)
		tweener.once_out(_event)
	)

func trigger_start():
	if (!active || !tweener.active || !tweener is AutoTween):
		return

	if (tween && tween.is_valid()):
		tween.kill()

	tween = tweener.create_tween()
	var event = TweenEvent.new(tween, tweener)
	tweener.show(event)

func trigger_end():
	if (!active || !tweener.active || !tweener is AutoTween):
		return

	if (tween && tween.is_valid()):
		tween.kill()

	tween = tweener.create_tween()
	var event = TweenEvent.new(tween, tweener)
	tweener.hide(event)
