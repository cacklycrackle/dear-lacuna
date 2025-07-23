extends BaseLevel

var tile_locations
var stand_arr
func _ready() -> void:
	super._ready()
	level_id = 6
	
	
	$Group2/Stand1.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Group2/Stand1.started.connect(_on_puzzle_started.bind(1))
	$Group2/Stand1.solved.connect(_on_puzzle_solved.bind(1))
	$Stand2.puzzle_base = preload("res://puzzles/sliding_puzzle/puzzle_base.tscn")
	$Stand2.started.connect(_on_puzzle_started.bind(2))
	$Stand2.solved.connect(_on_puzzle_solved.bind(2))
	
	stands_solved.resize(2)
	for i in range(stands_solved.size()):
		stands_solved[i] = GameManager.save_data[save_name]["stand_%d" % (i + 1)]
		if stands_solved[i]:
			stands_solved[i] = false
			_on_puzzle_solved(i + 1)
	tile_locations = [
		{
			"m" : [[0, 0]]
		},
		{
			"m" : [[0, 0]]
		}
	]
	stand_arr = [
		$Group2/Stand1,
		$Stand2
	]
	var player_inst = GameManager.spawn_player(self)
	add_child(player_inst)
	#VisionManager.init_vision_for_level()

func _on_puzzle_started(stand: int) -> void:
	var stand_node = stand_arr[stand - 1]
	stand_node.puzzle.tile_location = tile_locations[stand - 1]
	stand_node.puzzle.offset = stand_node.global_position

func _on_puzzle_solved(stand: int) -> void:
	if not stands_solved[stand - 1]:
		if stand == 1:
			$Group1/Platform1.global_position.y += 16 * 12
			$Group1/Platform2.global_position.y += 16 * 15
			$Group1/Chains.visible = true
		elif stand == 2:
			$Group2.global_position.y -= 16 * 14
			$Portal1.global_position.y -= 16 * 14
