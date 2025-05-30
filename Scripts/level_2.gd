extends Node2D

func _ready():
	$Portal_1.target_scene = "res://Scenes/Level_1.tscn"
	$Portal_1.target_portal = "Portal_1"
	var portal = get_node(GameManager.spawn_at_portal)
	var player_instance = GameManager.player.instantiate()
	player_instance.global_position = portal.global_position
	add_child(player_instance)
	$"Stand 1".puzzle_tiles = [[1,1,"2r"], [-2,1,"2u"], [2,2,"m"]]
	
