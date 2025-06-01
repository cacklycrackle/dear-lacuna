extends Control


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
