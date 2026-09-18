class_name TweenTranslateAnimation
extends TweenAnimation

@export var translate_offset: Vector2
var origin_position: Vector2

func _get_property(event: TweenEvent):
	return "offset_transform_position" if event.force_offset_transform else "position"

func once_in(event: TweenEvent) -> void:
	show(event)

func once_out(event: TweenEvent) -> void:
	hide(event)

func show(event: TweenEvent) -> void:
	origin_position = event.target.get(_get_property(event))
	event.tween.tween_property(event.target, _get_property(event), translate_offset, event.duration).as_relative()
	
func hide(event: TweenEvent) -> void:
	event.tween.tween_property(event.target, _get_property(event), origin_position, event.duration)