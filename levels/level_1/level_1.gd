extends Node2D


func _ready() -> void:
	#var portal = get_node(GameManager.spawn_at_portal)
	#var player_instance = GameManager.player.instantiate()
	$Portal1.target_scene = "res://levels/level_2/level_2.tscn"
	$Portal1.target_portal = "Portal1"
	#if GameManager.save_data["first_start"]:
		#GameManager.save_data["first_start"] = false
		#player_instance.global_position = Vector2(30, 500)
	#else:
		#player_instance.global_position = portal.global_position
	var player_inst = GameManager.spawn_player(self)
	if GameManager.save_data["first_start"]:
		GameManager.save_data["first_start"] = false
		player_inst.global_position = Vector2(30, 500)
	add_child(player_inst)
	VisionManager.init_vision_for_level()
