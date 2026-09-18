class_name MenuPage
extends Control

@export var initial_focus_node: Control

signal change_page(page_name: String)
signal go_to_last_page()

signal page_entered()
signal page_exited()

func on_page_exited() -> void:
	pass

func on_page_entered() -> void:
	if (initial_focus_node):
		initial_focus_node.grab_focus()