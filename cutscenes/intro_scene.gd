extends Node2D


func _ready() -> void:
	var e := InputMap.action_get_events("skip")[0]
	%SkipLabel.text = "Press ‘%s’ to skip" % e.as_text().trim_suffix(" (Physical)")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("skip"):
		_start_game()

func _start_game() -> void:
	$AnimationPlayer.pause()
	$DialogueUI.hide()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://common/ui/start_menu/start_menu.tscn")
