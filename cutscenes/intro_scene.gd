extends Node2D


func _ready() -> void:
	var e := InputMap.action_get_events("skip")[0]
	%SkipLabel.text = "Press ‘%s’ to skip" % e.as_text().trim_suffix(" (Physical)")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip"):
		_start_game()

func _start_game() -> void:
	$AnimationPlayer.pause()
	$DialogueUI.hide()
	GameManager.load_start_from(self)
