extends BaseLevel
func _ready() -> void:
	$Stand.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand.started.connect(_on_puzzle_started)
	$Stand.solved.connect(_on_puzzle_solved.bind(1))
	
func _on_puzzle_started() -> void:
	$Stand.puzzle.tile_location = {
			"m2" : [[1, 3]],
			"b" : [[3, 5]],
			"v2" : [[0, 4], [0, 2], [3, 3], [2, 1]],
			"h2" : [[1, 5], [4, 4], [3, 2], [0, 1], [0, 0]],
			"v3" : [[5, 0]],
			"h3" : [[2, 0]]
			}
	$Stand.puzzle.offset = $Stand.global_position

func _on_puzzle_solved(stand: int) -> void:
	pass
