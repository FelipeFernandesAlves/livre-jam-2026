@abstract
class_name CustomTweener
extends Node

@export var target: Node:
	set(value):
		target = value
		
		if (target is Control):
			target.offset_transform_enabled = tweener_properties.force_offset_transform
		else:
			tweener_properties.force_offset_transform = false
		
		target_changed.emit()

@export var active: bool = true
@export var tweener_properties: TweenerProperties

signal target_changed()

func _ready() -> void:
	if (!target):
		target = get_parent()
	
