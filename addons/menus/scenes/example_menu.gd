extends MenuManager

func _on_go_to_page_2_pressed() -> void:
	change_page("Secondary")

func _on_go_to_page_3_pressed() -> void:
	change_page("Tertiary")

func _on_go_back_pressed() -> void:
	go_to_last_page()
