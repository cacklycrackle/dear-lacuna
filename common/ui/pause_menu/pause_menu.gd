extends Control

var save_menu = preload("res://common/ui/save_menu/save_menu.tscn")

var is_paused: bool = false:
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not GameManager.in_puzzle:
		is_paused = not is_paused

func _on_resume_button_pressed() -> void:
	is_paused = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_save_pressed() -> void:
	print("hi")
	var save_menu_int = save_menu.instantiate()
	is_paused = false
	get_tree().root.add_child(save_menu_int)
	get_tree().paused = true
	save_menu_int.process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.
