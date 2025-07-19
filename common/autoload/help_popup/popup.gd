extends Control


func show_help(description: String) -> void:
	%HelpPopup.size = Vector2i.ZERO
	%Description.text = description
	var pos := 0.95 * get_viewport_rect().size
	var padding := 10
	#var correction
	
	if pos.x <= get_viewport_rect().size.x / 2:
		#correction = Vector2(size.x + padding, 0)
		pos.x += size.x + padding
	else:
		#correction = -Vector2(%HelpPopup.size.x + padding, 0)
		pos.x -= %HelpPopup.size.x + padding
	pos.y -= 2 * padding
	#%HelpPopup.popup(Rect2i(Vector2i(pos + correction), %HelpPopup.size))
	%HelpPopup.popup(Rect2i(Vector2i(pos), %HelpPopup.size))
	%HelpPopup.grab_focus()

func hide_help() -> void:
	%HelpPopup.hide()
