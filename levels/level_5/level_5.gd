extends BaseLevel


func _ready() -> void:
	super._ready()
	level_id = 5
	
	$Portal1.target_scene = "res://levels/level_4/level_4.tscn"
	$Portal1.target_portal = "Portal2"
	$Portal2.target_scene = "res://common/ui/start_menu/start_menu.tscn"
	$Portal2.target_portal = "Portal1"
	
	$Stand1.puzzle_base = preload("res://common/slingshot_puzzle/puzzle_base.tscn")
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	$Stand2.puzzle_base = preload("res://common/sliding_puzzle/puzzle_base.tscn")
	$Stand2.started.connect(_on_puzzle_started.bind(2))
	$Stand2.solved.connect(_on_puzzle_solved.bind(2))
	stands_solved.resize(2)
	for i in range(stands_solved.size()):
		stands_solved[i] = GameManager.save_data[save_name]["stand_%d" % (i + 1)]
		if stands_solved[i]:
			stands_solved[i] = false
			_on_puzzle_solved(i + 1)
	
	var player_inst = GameManager.spawn_player(self)
	add_child(player_inst)
	VisionManager.init_vision_for_level()

func _on_puzzle_started(stand: int) -> void:
	if stand == 2:
		var stand_node = get_node("Stand%d" % stand)
		#stand_node.puzzle.tile_location = {
			#"h2" : [[-2, 3], [-1, -2], [0, -1], [1, 2], [2, -2], [2, 1]],
			#"v2" : [[-2, -1], [-1, 0], [0, 3], [1, 1], [2, 0], [3, 3]],
			#"m" : [[0, 0]]
		#}
		stand_node.puzzle.tile_location = SlidingPuzzleGenerator.generate_tiles()
		stand_node.puzzle.offset = stand_node.global_position

func _on_puzzle_solved(stand: int) -> void:
	if not stands_solved[stand - 1]:
		var wall = get_node("Wall%d" % stand)
		wall.visible = false
		wall.get_node("TileMapLayer").collision_enabled = false
		stands_solved[stand - 1] = true
		GameManager.save_data[save_name]["stand_%d" % stand] = true
