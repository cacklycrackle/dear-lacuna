extends BaseLevel


func _init() -> void:
	level_id = 7

func _ready() -> void:
	super._ready()
	
	$Stand1.puzzle_base = preload("res://puzzles/slingshot_puzzle/puzzle_base.tscn")
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	$Stand2.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand2.started.connect(_on_puzzle_started.bind(2))
	$Stand2.solved.connect(_on_puzzle_solved.bind(2))
	stands_solved.resize(2)
	for i in range(1, stands_solved.size() + 1):
		if GameManager.save_data[save_name]["stand_%d" % i]:
			_on_puzzle_solved(i)

func _on_puzzle_started(stand: int) -> void:
	if stand == 2:
		var stand_node = get_node("Stand%d" % stand)
		stand_node.puzzle.tile_location = {
			"m" : [[0, 0]]
		}
		stand_node.puzzle.offset = stand_node.global_position

func _on_puzzle_solved(stand: int) -> void:
	if not stands_solved[stand - 1]:
		var wall := get_node("Stand%d/LockedLayer" % stand)
		wall.collision_enabled = false
		wall.visible = false
		stands_solved[stand - 1] = true
		GameManager.save_data[save_name]["stand_%d" % stand] = true
