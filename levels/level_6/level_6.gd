extends BaseLevel


var tile_locations
var stand_arr


func _ready() -> void:
	super._ready()
	level_id = 6
	
	$Stand1.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand1.started.connect(_on_puzzle_started.bind(1))
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	$Stand2.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand2.started.connect(_on_puzzle_started.bind(2))
	$Stand2.solved.connect(_on_puzzle_solved.bind(2))
	
	stands_solved.resize(2)
	for i in range(1, stands_solved.size() + 1):
		if GameManager.save_data[save_name]["stand_%d" % i]:
			_on_puzzle_solved(i)
	tile_locations = [
		{
			"v2": [[0, 2], [0, 4], [2, 2], [3, 3], [5, 0], [5, 4]],
			"h2": [[0, 1], [1, 4], [1, 5], [2, 0], [2, 1], [4, 2]],
			"m" : [[4, 0]]
		},
		{
			"v2": [[0, 0], [0, 4], [2, 2], [3, 1], [3, 4], [5, 0]],
			"h2": [[0, 3], [1, 1], [1, 4], [1, 5], [2, 0], [3, 3]],
			"m" : [[1, 2]]
		}
	]
	
	var player_inst = GameManager.spawn_player(self)
	add_child(player_inst)
	VisionManager.init_vision_for_level()

func _on_puzzle_started(stand: int) -> void:
	var stand_node = get_node("Stand%d" % stand)
	stand_node.puzzle.tile_location = tile_locations[stand - 1]
	stand_node.puzzle.offset = stand_node.global_position

func _on_puzzle_solved(stand: int) -> void:
	if not stands_solved[stand - 1]:
		if stand == 1:
			$Group1/Platform1.global_position.y += 16 * 9
			$Group1/Platform2.global_position.y += 16 * 7
			$Group1/Chains.visible = true
		elif stand == 2:
			for node in get_tree().get_nodes_in_group("left_rising"):
				node.global_position.y -= 16 * 14
			#$Group2.global_position.y -= 16 * 14
			#$Portals/Prev.global_position.y -= 16 * 14
		stands_solved[stand - 1] = true
		GameManager.save_data[save_name]["stand_%d" % stand] = true
