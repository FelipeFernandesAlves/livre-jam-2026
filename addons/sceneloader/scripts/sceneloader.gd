class_name SceneLoader
extends Node

signal progress_changed(progress)
signal load_finished()

@export var loading_screen: PackedScene = null

@export var control_parent: Control
@export var node2d_parent: Node2D
@export var node_parent: Node

var current_control_scene: Control
var current_node2D_scene: Node2D
var current_node_scene: Node

var parent: Node = self
var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true

var loaded_resource_instance: Node

signal control_loaded()
signal node_loaded()
signal node2D_loaded()

func _ready() -> void:
	SceneManager.instance = self
	set_process(false)

func load_scene(_scene_path: String, _parent: Node = self) -> void:
	scene_path = _scene_path
	parent = _parent

	if (loading_screen):
		var new_load_screen = loading_screen.instantiate()
		add_child(new_load_screen)
		progress_changed.connect(new_load_screen._on_progress_changed)
		load_finished.connect(new_load_screen._on_load_finished)
		await new_load_screen.loading_screen_ready
		
	_start_load()

func _start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if (state == OK):
		set_process(true)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_changed.emit(progress[0])

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			loaded_resource_instance = loaded_resource.instantiate()
			parent.add_child(loaded_resource_instance)
			load_finished.emit()

func load_control(_scene_path: String):
	if (!control_parent):
		return
	
	if (current_control_scene):
		current_control_scene.queue_free()
	
	load_scene(_scene_path, control_parent)
	await load_finished
	current_control_scene = loaded_resource_instance
	control_loaded.emit()

func load_node2D(_scene_path: String):
	if (!node2d_parent):
		return
	
	if (current_node2D_scene):
		current_node2D_scene.queue_free()
	
	load_scene(_scene_path, node2d_parent)
	await load_finished
	current_node2D_scene = loaded_resource_instance
	node2D_loaded.emit()

func load_node(_scene_path: String):
	if (!node_parent):
		return

	if (current_node_scene):
		current_node_scene.queue_free()
	
	load_scene(_scene_path, node_parent)
	await load_finished
	current_node_scene = loaded_resource_instance
	node_loaded.emit()

func restart_control_scene():
	load_control(current_control_scene.scene_file_path)

func restart_node_scene():
	load_node(current_node_scene.scene_file_path)

func restart_node2D_scene():
	load_node2D(current_node2D_scene.scene_file_path)

func remove_control():
	if (current_control_scene):
		current_control_scene.queue_free()
	current_control_scene = null

func remove_node2D():
	if (current_node2D_scene):
		current_node2D_scene.queue_free()
	current_node2D_scene = null

func remove_node():
	if (current_node_scene):
		current_node_scene.queue_free()
	current_node_scene = null
