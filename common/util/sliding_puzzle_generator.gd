extends RefCounted
class_name SlidingPuzzleGenerator

const GRID_SIZE = 6
const END_POS = Vector2i(5, 3)
const MOVES = {
	AXIS.M: [1, GRID_SIZE, -GRID_SIZE, -1],
	AXIS.X: [-1, 1],
	AXIS.Y: [GRID_SIZE, -GRID_SIZE],
}
const AXIS := BaseTile.AxisType

static func generate_tiles():
	var board: String
	var queue: Array[String] = []
	while true:
		board = _create_board()
		queue.clear()
		queue.push_back(board)
		if _bfs(queue): break
	
	var locs: Dictionary[AXIS, Array] = {}
	var seen: Dictionary[int, bool] = {} # set of seen tile positions
	for ax in MOVES.keys():
		var arr: Array[Vector2i] = []
		var start := -1
		var c := str(ax)
		while true:
			start = board.find(c, start + 1)
			if start == -1: break
			if seen.has(start): continue
			for coord in _get_tile_coords(ax, start): seen[coord] = true
			arr.push_back(Vector2i(start % GRID_SIZE, start / GRID_SIZE))
		locs[ax] = arr
	return locs
			
	
static func _create_board() -> String:
	var board: PackedStringArray =  '0'.repeat(GRID_SIZE * GRID_SIZE).split()
	
	# Add main tile
	var pstart := Vector2i(randi() % (GRID_SIZE / 2), randi() % GRID_SIZE)
	board[pstart.y * GRID_SIZE + pstart.x] = str(AXIS.M)
	
	# Add secondary tiles
	var coords: Array[int]
	for _i in range(GRID_SIZE):
		for ax in [AXIS.X, AXIS.Y]:
			coords = _get_tile_coords(ax, 0)
			for _j in range(10):
				var start = randi() % (GRID_SIZE * GRID_SIZE)
				if _is_valid_tile("".join(board), coords, start):
					print("Axis {axis}, Start: {start}".format({"axis": ax, "start": start}))
					for coord in coords:
						board[coord + start] = str(ax)
					break
	return "".join(board)

static func _bfs(queue: Array[String]) -> bool:
	var seen: Dictionary[String, bool] = {}
	while not queue.is_empty():
		if seen.size() > 1e6: return false
		var board: String = queue.pop_front()
		if _is_end_state(board): return true
		if seen.has(board): continue
		#print(board)
		seen[board] = true
		_find_next_states(queue, board)
	return false

static func _find_next_states(queue: Array[String], state: String) -> void:
	var seen: Dictionary[int, bool] = {}
	for ax in MOVES:
		var c := str(ax)
		var start := -1
		while true:
			start = state.find(c, start + 1)
			if start == -1: break
			if seen.has(start): continue
			
			var coords := _get_tile_coords(ax, start)
			for coord in coords: seen[coord] = true
			for delta in MOVES[ax]:
				if _is_valid_move(state, coords, delta):
					var moved := String(state)
					for coord in coords: moved[coord] = '0'
					for coord in coords: moved[coord + delta] = c
					queue.push_back(moved)

static func _get_tile_coords(axis: AXIS, start: int) -> Array[int]:
	match axis:
		AXIS.X:
			return [start, start + 1]
		AXIS.Y:
			return [start, start + GRID_SIZE]
		AXIS.M:
			return [start]
		_:
			return []

static func _is_valid_move(state: String, coords: Array[int], delta: int) -> bool:
	var c := state[coords[0]]
	for coord in coords: state[coord] = '0'
	var valid: bool = _is_valid_tile(state, coords, delta)
	for coord in coords: state[coord] = c
	return valid

static func _is_valid_tile(state: String, coords: Array[int], delta: int) -> bool:
	for coord in coords:
		var nc = coord + delta
		if nc < 0 or nc >= state.length() \
		or (delta != 0 and nc % GRID_SIZE - coord % GRID_SIZE != delta % GRID_SIZE) \
		or state[nc] != '0':
			return false
	return true

static func _is_end_state(state: String) -> bool:
	return state[END_POS.y * GRID_SIZE + END_POS.x] == str(AXIS.M)
