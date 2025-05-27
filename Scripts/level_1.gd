extends Node2D


func _ready() -> void:
	var portal = get_node(GameManager.spawn_at_portal)
	var player_instance = GameManager.player.instantiate()
	$Portal_1.target_scene = "res://Scenes/Level_2.tscn"
	$Portal_1.target_portal = "Portal_1"
	if GameManager.first_start:
		GameManager.first_start = false
		player_instance.global_position = Vector2(30, 500)
	else:
		player_instance.global_position = portal.global_position	
	add_child(player_instance)
		
		
