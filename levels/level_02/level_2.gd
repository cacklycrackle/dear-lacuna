extends Node2D

func _ready():
	$Portal1.target_scene = "res://levels/level_01/level_1.tscn"
	$Portal1.target_portal = "Portal1"
	var portal = get_node(GameManager.spawn_at_portal)
	var player_instance = GameManager.player.instantiate()
	player_instance.global_position = portal.global_position
	add_child(player_instance)
	#$Stand1.puzzle_tiles = [[1,1,"2r"], [-2,1,"2u"], [2,2,"m"]]
