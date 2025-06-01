extends Node2D


func _ready() -> void:
	var portal = get_node(GameManager.spawn_at_portal)
	var player_instance = GameManager.player.instantiate()
	$Portal1.target_scene = "res://levels/level_02/level_2.tscn"
	$Portal1.target_portal = "Portal1"
	if GameManager.first_start:
		GameManager.first_start = false
		player_instance.global_position = Vector2(30, 500)
	else:
		player_instance.global_position = portal.global_position
	add_child(player_instance)
