class_name TweenFadeAnimation
extends TweenAnimation
		
func once_in(event: TweenEvent) -> void:
	hide(event)

func once_out(event: TweenEvent) -> void:
	show(event)

func show(auto_tween: TweenEvent) -> void:
	if (auto_tween.force_from):
		auto_tween._tween.tween_property(auto_tween.target, "modulate:a", 1.0, auto_tween.duration).from(0.0)
	else:
		auto_tween._tween.tween_property(auto_tween.target, "modulate:a", 1.0, auto_tween.duration)

func hide(auto_tween: TweenEvent) -> void:
	if (auto_tween.force_from):
		auto_tween._tween.tween_property(auto_tween.target, "modulate:a", 0.0, auto_tween.duration).from(1.0)
	else:
		auto_tween._tween.tween_property(auto_tween.target, "modulate:a", 0.0, auto_tween.duration)
