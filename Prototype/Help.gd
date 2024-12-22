extends CanvasLayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spacebar"):
		Global.go_to_menu_page()
