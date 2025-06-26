extends Node2D


var save_name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_name = name.to_snake_case()
	$Portal1.target_scene = "res://levels/level_2/level_2.tscn"
	$Portal1.target_portal = "Portal2"
	$Portal2.target_scene = "res://common/ui/start_menu/start_menu.tscn"
	$Portal2.target_portal = "Portal1"
	
	var player_instance = GameManager.player.instantiate()
	if GameManager.load_from_save:
		GameManager.load_from_save = false
		var coords_str = GameManager.save_data["position"]
		var coords = coords_str.substr(1, coords_str.length() - 2).split(",")
		player_instance.global_position = Vector2(coords[0].to_float(), coords[1].to_float())
	else:
		var portal = get_node(GameManager.spawn_at_portal)
		player_instance.global_position = portal.global_position
	add_child(player_instance)
	player_instance.add_to_group("player_group")
	VisionManager.init_vision_for_level()
