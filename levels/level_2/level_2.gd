extends BaseLevel


func _ready() -> void:
	super._ready()
	level_id = 2
	
	$Portal1.target_scene = "res://levels/level_1/level_1.tscn"
	$Portal1.target_portal = "Portal1"
	$Portal2.target_scene = "res://levels/level_3/level_3.tscn"
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
	$Stand1.puzzle.tile_location = {
		"v2" : [[-2, -2], [-2, 0], [-2, 2], [-1, 0], [-1 ,2], [1, -1], [3, -1]],
		"h2" : [[0, 1], [0, 2], [0, 3], [2, 1], [-1, -1], [-1, -2], [1, -2]],
		"m" : [[0, 0]]
	}
	$Stand1.puzzle.offset = $Stand1.global_position

func _on_puzzle_solved(stand: int) -> void:
	if not stands_solved[stand - 1]:
		$Wall.visible = false
		$Wall/TileMapLayer.collision_enabled = false
		stands_solved[stand - 1] = true
		GameManager.save_data[save_name]["stand_1"] = true
