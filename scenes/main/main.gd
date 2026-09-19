extends Node2D

@export var splash_screen: PackedScene
@export var initial_scene: PackedScene
@export var pause_menu: PackedScene
@export var scene_loader: SceneLoader

func _ready() -> void:
	# Instantiate splash screen
	if (splash_screen):
		scene_loader.load_control(splash_screen.resource_path)
		await scene_loader.control_loaded
		scene_loader.current_control_scene.connect("splash_screen_ended", _start_game)
		return
	
	_start_game()
	
func _start_game():
	scene_loader.remove_control()
	scene_loader.load_node2D(initial_scene.resource_path)
	if (pause_menu):
		scene_loader.load_control(pause_menu.resource_path)

		
