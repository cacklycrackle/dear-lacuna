extends BaseLevel


func _ready() -> void:
	super._ready()
	level_id = 2
	
	$Stand1.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand1.started.connect(_on_puzzle_started)
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	stands_solved.resize(1)
	for i in range(1, stands_solved.size() + 1):
		if GameManager.save_data[save_name]["stand_%d" % i]:
			_on_puzzle_solved(i)
	

func _on_puzzle_started() -> void:
	$Stand1.puzzle.tile_location = {
		"v2" : [[0, 4], [0, 2], [0, 0], [1, 2], [1, 0], [3, 3], [5, 3]],
		"h2" : [[2, 2], [2, 1], [2, 0], [4, 2], [1, 4], [1, 5], [3, 5]],
		"m" : [[2, 3]]
	}
	$Stand1.puzzle.offset = $Stand1.global_position

func _on_puzzle_solved(stand: int) -> void:
	if stands_solved[stand - 1]: return
	var wall := get_node("Stand%d/LockedLayer" % stand)
	wall.collision_enabled = false
	wall.visible = false
	stands_solved[stand - 1] = true
	GameManager.save_data[save_name]["stand_%d" % stand] = true
