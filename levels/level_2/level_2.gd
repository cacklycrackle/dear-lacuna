extends Node2D


var save_name: String
var stand1_solved


func _ready() -> void:
	save_name = name.to_snake_case()
	stand1_solved = GameManager.save_data[save_name]["stand_1"]
	$Portal1.target_scene = "res://levels/level_1/level_1.tscn"
	$Portal1.target_portal = "Portal1"
	$Portal2.target_scene = "res://levels/level_3/level_3.tscn"
	$Portal2.target_portal = "Portal1"
	
	$Stand1.puzzle_base = preload("res://common/sliding_puzzle/puzzle_base.tscn")
	$Stand1.started.connect(_on_puzzle_started)
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	if stand1_solved:
		stand1_solved = false
		_on_puzzle_solved(1)
	
	#var player_instance = GameManager.player.instantiate()
	#if GameManager.load_from_save:
		#GameManager.load_from_save = false
		#var coords_str = GameManager.save_data["position"]
		#var coords = coords_str.substr(1, coords_str.length() - 2).split(",")
		#player_instance.global_position = Vector2(coords[0].to_float(), coords[1].to_float())
	#else:
		#var portal = get_node(GameManager.spawn_at_portal)
		#player_instance.global_position = portal.global_position
	GameManager.curr_level = 2
	var player_inst = GameManager.spawn_player(self)
	add_child(player_inst)
	VisionManager.init_vision_for_level()

func _on_puzzle_started() -> void:
	$Stand1.puzzle.tile_location = {
		"v2" : [[-2, -2], [-2, 0], [-2, 2], [-1, 0], [-1 ,2], [1, -1], [3, -1]],
		"h2" : [[0, 1], [0, 2], [0, 3], [2, 1], [-1, -1], [-1, -2], [1, -2]],
		"m" : [[0, 0]]
	}
	$Stand1.puzzle.offset = $Stand1.global_position

func _on_puzzle_solved(stand) -> void:
	if stand == 1 and not stand1_solved:
		$Wall.position.y -= 150
		stand1_solved = true
		GameManager.save_data[save_name]["stand_1"] = true
