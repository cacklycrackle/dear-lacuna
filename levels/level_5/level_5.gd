extends BaseLevel


func _init() -> void:
	level_id = 5

func _ready() -> void:
	super._ready()
	
	$Stand1.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand1.started.connect(_on_puzzle_started.bind(1))
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	$Stand2.puzzle_base = preload("res://puzzles/slingshot_puzzle/puzzle_base.tscn")
	$Stand2.solved.connect(_on_puzzle_solved.bind(2))
	stands_solved.resize(2)
	for i in range(1, stands_solved.size() + 1):
		if GameManager.save_data[save_name]["stand_%d" % i]:
			_on_puzzle_solved(i)

func _on_puzzle_started(stand: int) -> void:
	if stand == 1:
		var stand_node = get_node("Stand%d" % stand)
		stand_node.puzzle.tile_location = {
			"v2": [[0, 4], [1, 3], [2, 0], [3, 2], [4, 3], [5, 0]],
			"h2": [[0, 0], [1, 5], [2, 4], [3, 1], [4, 5], [4, 2]],
			"m" : [[2, 3]]
		}
		stand_node.puzzle.offset = stand_node.global_position

func _on_puzzle_solved(stand: int) -> void:
	if stands_solved[stand - 1]: return
	var wall := get_node("Stand%d/LockedLayer" % stand)
	wall.collision_enabled = false
	wall.visible = false
	stands_solved[stand - 1] = true
	GameManager.save_data[save_name]["stand_%d" % stand] = true
