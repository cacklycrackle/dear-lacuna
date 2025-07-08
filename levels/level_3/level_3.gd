extends BaseLevel


func _ready() -> void:
	super._ready()
	level_id = 3
	
	$Portal1.target_scene = "res://levels/level_2/level_2.tscn"
	$Portal1.target_portal = "Portal2"
	$Portal2.target_scene = "res://levels/level_4/level_4.tscn"
	$Portal2.target_portal = "Portal1"
	
	$Stand1.puzzle_base = preload("res://common/sliding_puzzle/puzzle_base.tscn")
	$Stand1.started.connect(_on_puzzle_started)
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	stands_solved.resize(1)
	for i in range(stands_solved.size()):
		stands_solved[i] = GameManager.save_data[save_name]["stand_%d" % (i + 1)]
		if stands_solved[i]:
			stands_solved[i] = false
			_on_puzzle_solved(i + 1)
	
	var player_inst = GameManager.spawn_player(self)
	add_child(player_inst)
	VisionManager.init_vision_for_level()

func _on_puzzle_started() -> void:
	#$Stand1.puzzle.tile_location = {
		#"h2" : [[-2, 3], [-2, 2], [-1, -2], [-1, -1], [0, 2], [0, 3], [1, 1]],
		#"v2" : [[-2, -1], [-2, 1], [0, 1], [1 ,-1], [2, -1], [2, 3]],
		#"m" : [[-1, 1]]
	#}
	$Stand1.puzzle.tile_location = SlidingPuzzleGenerator.generate_tiles()
	$Stand1.puzzle.offset = $Stand1.global_position

func _on_puzzle_solved(stand: int) -> void:
	if not stands_solved[stand - 1]:
		$Wall.visible = false
		$Wall/TileMapLayer.collision_enabled = false
		stands_solved[stand - 1] = true
		GameManager.save_data[save_name]["stand_%d" % stand] = true
