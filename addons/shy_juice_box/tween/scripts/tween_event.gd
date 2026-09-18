class_name TweenEvent

var tween: Tween:
	get(): return _tween
	set(value): _block_mutation()

var target: Node:
	get(): return _target
	set(value): _block_mutation()

var duration: float:
	get(): return _duration
	set(value): _block_mutation()

var force_offset_transform: bool:
	get(): return _force_offset_transform
	set(value): _block_mutation()

var force_from: bool:
	get(): return _force_from
	set(value): _block_mutation()

var _tween: Tween
var _target: Node
var _duration: float
var _force_offset_transform: bool
var _force_from: bool

func _init(p_tween: Tween, custom_tweener: CustomTweener) -> void:
	var properties: TweenerProperties = custom_tweener.tweener_properties
	if (!properties):
		return

	self._tween = p_tween
	self._target = custom_tweener.target
	self._duration = properties.duration
	self._force_offset_transform = properties.force_offset_transform
	self._force_from = properties.force_from

func _block_mutation() -> void:
	assert(false, "Error: ItemData is an immutable class and cannot be modified after creation.")
