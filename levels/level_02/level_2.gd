extends Node2D
var stand1_solved = false

func _ready():
	$Portal1.target_scene = "res://levels/level_01/level_1.tscn"
	$Portal1.target_portal = "Portal1"
	var portal = get_node(GameManager.spawn_at_portal)
	var player_instance = GameManager.player.instantiate()
	player_instance.global_position = portal.global_position
	add_child(player_instance)
	$Stand1.puzzle_tiles_dict = {
		"v2" : [[-2, -2], [-2, 0], [-2, 2], [-1, 0], [-1 ,2], [1, -1], [3, -1]],
		"h2" : [[0, 1], [0, 2], [0, 3], [2, 1], [-1, -1], [-1, -2], [1, -2]],
		"m" : [[0, 0]]
		}
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	
	
func _on_puzzle_solved(stand):
	if stand == 1 and not stand1_solved:
		$Wall.position.y -= 100
		stand1_solved = true
	
