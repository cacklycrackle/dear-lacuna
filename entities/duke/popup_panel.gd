extends PopupPanel


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("w")
		print(get_parent().get_parent().chunks)
		get_parent().get_parent().speech()
