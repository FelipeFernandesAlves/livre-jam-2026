class_name TweenScaleAnimation
extends TweenAnimation

@export var once_scale_in: float = 1.0
@export var scale_from: TweenEnums.PIVOT_POINTS

func _set_pivot(target: Node):
	var offset_ratio = Vector2.ZERO
	
	match scale_from:
		TweenEnums.PIVOT_POINTS.CENTER:
			offset_ratio = Vector2(0.5, 0.5)
		TweenEnums.PIVOT_POINTS.TOP_CENTER:
			offset_ratio = Vector2(0.5, 0.0)
		TweenEnums.PIVOT_POINTS.TOP_RIGHT:
			offset_ratio = Vector2(1.0, 0.0)
		TweenEnums.PIVOT_POINTS.BOTTOM_LEFT:
			offset_ratio = Vector2(0.0, 1.0)
		TweenEnums.PIVOT_POINTS.BOTTOM_CENTER:
			offset_ratio = Vector2(0.5, 1.0)
		TweenEnums.PIVOT_POINTS.BOTTOM_RIGHT:
			offset_ratio = Vector2(1.0, 1.0)

	target.offset_transform_pivot_ratio = offset_ratio	
	target.pivot_offset_ratio = offset_ratio

func once_in(event: TweenEvent) -> void:
	var tween = event._tween
	var property := "offset_transform_scale" if event.force_offset_transform else "scale"
	_set_pivot(event.target)

	if (event.force_from):
		tween.tween_property(event.target, property, Vector2(once_scale_in, once_scale_in), event.duration).from(Vector2.ONE)
	else:
		tween.tween_property(event.target, property, Vector2(once_scale_in, once_scale_in), event.duration)

func once_out(event: TweenEvent) -> void:
	var tween = event._tween
	var property := "offset_transform_scale" if event.force_offset_transform else "scale"
	_set_pivot(event.target)

	if (event.force_from):
		tween.tween_property(event.target, property, Vector2.ONE, event.duration).from(Vector2(once_scale_in, once_scale_in))
	else:
		tween.tween_property(event.target, property, Vector2.ONE, event.duration)

func show(event: TweenEvent) -> void:
	var tween = event._tween
	var property := "offset_transform_scale" if event.force_offset_transform else "scale"
	_set_pivot(event.target)

	if (event.force_from):
		tween.tween_property(event.target, property, Vector2.ONE, event.duration).from(Vector2.ZERO)
	else:
		tween.tween_property(event.target, property, Vector2.ONE, event.duration)

func hide(event: TweenEvent) -> void:
	var tween = event._tween
	var property := "offset_transform_scale" if event.force_offset_transform else "scale"
	_set_pivot(event.target)

	if (event.force_from):
		tween.tween_property(event.target, property, Vector2.ZERO, event.duration).from(Vector2.ONE)
	else:
		tween.tween_property(event.target, property, Vector2.ZERO, event.duration)
