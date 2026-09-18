class_name Squesh
extends Node

@export var sprites: AnimatedSprite2D
@export var duration: float = 0.25
@export var magnitude: float = 0.25

@export var ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition: Tween.TransitionType = Tween.TransitionType.TRANS_BACK

@export var custom_base_scale: Vector2 = Vector2(1, 1)

var tween: Tween
var original_scale: Vector2 = Vector2.ZERO

var in_animation: bool = false

func _create_tween():
	if (!in_animation):
		original_scale = sprites.scale

		if (sprites.scale != custom_base_scale):
			original_scale = custom_base_scale

	in_animation = true
		
	if (tween && tween.is_valid()):
		tween.kill()
	
	tween = create_tween().set_ease(ease).set_trans(transition)

func _end_tween():
	if (tween && tween.is_valid()):
		tween.kill()

	tween = create_tween().set_trans(transition).set_ease(ease)
	tween.tween_property(sprites, "scale:x", original_scale.x, duration/2)
	tween.parallel().tween_property(sprites, "scale:y", original_scale.y, duration/2)

	tween.tween_callback(func():
		in_animation = false
	)

func _squash_animation():
	tween.tween_property(sprites, "scale:x", original_scale.x + magnitude, duration/2)
	tween.parallel().tween_property(sprites, "scale:y", original_scale.y - magnitude, duration/2)

func _stretch_animation():
	tween.tween_property(sprites, "scale:x", original_scale.x - magnitude, duration/2)
	tween.parallel().tween_property(sprites, "scale:y", original_scale.y + magnitude, duration/2)
	

func squash():
	if (!sprites):
		push_warning("Squesh without valid sprite!")
		return

	_create_tween()
	_squash_animation()
	tween.tween_callback(_end_tween)

func stretch():
	if (!sprites):
		push_warning("Squesh without valid sprite!")
		return

	_create_tween()
	_stretch_animation()
	tween.tween_callback(_end_tween)

func squash_and_stretch():
	if (!sprites):
		push_warning("Squesh without valid sprite!")
		return
	
	_create_tween()
	_squash_animation()
	tween.tween_callback(func():
		stretch()
		)



func stretch_and_squash():
	if (!sprites):
		push_warning("Squesh without valid sprite!")
		return
	
	_create_tween()
	_stretch_animation()
	tween.tween_callback(func():
		squash()
		)
	