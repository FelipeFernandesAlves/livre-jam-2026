@abstract
class_name PlayerState
extends State

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")