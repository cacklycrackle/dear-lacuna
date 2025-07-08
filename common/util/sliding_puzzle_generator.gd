extends RefCounted
class_name SlidingPuzzleGenerator


const GRID_SIZE = 6
const EXIT_POS = Vector2i(5, 3)
const AXIS = BaseTile.AxisType

class _Tile:
	var axis: AXIS
	var start: Vector2i
	
	func _init(p_axis: AXIS, p_start: Vector2i = Vector2i.ZERO) -> void:
		self.axis = p_axis
		self.start = p_start
	
	func _to_string() -> String:
		return "Tile({0}, {1})".format([self.axis, self.start])
	
	static func _get_coords(tile: _Tile) -> Array[Vector2i]:
		match tile.axis:
			AXIS.X:
				return [tile.start, tile.start + Vector2i.RIGHT]
			AXIS.Y:
				return [tile.start, tile.start + Vector2i.DOWN]
			AXIS.M:
				return [tile.start]
			_:
				return []
	
	static func _get_scramble_moves(tile: _Tile) -> Array[Vector2i]:
		match tile.axis:
			AXIS.X:
				return [Vector2i.LEFT, Vector2i.RIGHT]
			AXIS.Y:
				return [Vector2i.UP, Vector2i.DOWN]
			AXIS.M:
				return [Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN]
			_:
				return []


static func generate_tiles():
	var grid := _create_empty_grid() # Array[Array[int]]
	#_print_grid(grid)
	if grid.is_empty(): return null
	
	var sec_tiles: Array[_Tile] = []
	var moves: Array[Vector2i]
	
	# Place main tile at exit
	var main_tile = _Tile.new(AXIS.M, EXIT_POS)
	_set_tile(grid, main_tile)
	
	# Add some secondary tiles at random positions
	var n = randi_range(4, 6)
	for i in range(n):
		for orientation in [AXIS.X, AXIS.Y]:
			for attempt in range(20):
				var tile = _Tile.new(
					orientation,
					Vector2i(randi() % GRID_SIZE, randi() % GRID_SIZE)
				)
				#print(pos)
				
				if _is_tile_valid(grid, tile):
					_set_tile(grid, tile)
					sec_tiles.append(tile)
					break
	#print(sec_tiles)
	#_print_grid(grid)
	
	# Scramble secondary tiles
	for attempt in range(20):
		var tile_to_move = sec_tiles.pick_random()
		assert(tile_to_move != null, "ERROR: No secondary tiles generated")
		#if tile_to_move == null:
			#push_error("ERROR: No secondary tiles generated")
			#return
		
		_scramble_tile_if_possible(grid, tile_to_move)
		_scramble_tile_if_possible(grid, main_tile)
		#print(main_tile)
	
	# Create result
	var tile_locs = {
		AXIS.X: [],
		AXIS.Y: [],
		AXIS.M: [main_tile.start],
	}
	for tile in sec_tiles:
		tile_locs[tile.axis].append(tile.start)
	#_print_grid(grid)
	return tile_locs
	
static func _create_empty_grid() -> Array[PackedByteArray]:
	var grid: Array[PackedByteArray] = []
	if grid.resize(GRID_SIZE) != OK:
		print("ERROR: in creating grid")
	for i in range(GRID_SIZE):
		grid[i] = PackedByteArray()
		if grid[i].resize(GRID_SIZE) != OK:
			print("ERROR: in creating grid")
			return []
	return grid

static func _is_tile_valid(grid: Array[PackedByteArray], tile: _Tile) -> bool:
	var positions = _Tile._get_coords(tile)
	assert(positions, "ERROR: Unexpected tile axis when positioning")
	for pos in positions:
		if pos.x < 0 or pos.x >= GRID_SIZE or pos.y < 0 or pos.y >= GRID_SIZE or grid[pos.y][pos.x] != 0:
			return false
	return true

static func _is_move_valid(grid: Array[PackedByteArray], tile: _Tile, offset: Vector2i) -> bool:
	_set_tile(grid, tile, true)
	tile.start += offset
	var valid = _is_tile_valid(grid, tile)
	tile.start -= offset
	_set_tile(grid, tile)
	return valid

static func _scramble_tile_if_possible(grid: Array[PackedByteArray], tile: _Tile) -> void:#, offset: Vector2i):
	var moves: Array[Vector2i] = _Tile._get_scramble_moves(tile)
	assert(moves, "ERROR: Unexpected tile axis when scrambling")
	var valid_moves: Array[Vector2i] = moves.filter(
		func(move): return _is_move_valid(grid, tile, move)
	)
	
	if not valid_moves.is_empty():
		_set_tile(grid, tile, true)
		tile.start += valid_moves.pick_random()
		_set_tile(grid, tile)

static func _set_tile(grid: Array[PackedByteArray], tile: _Tile, remove: bool = false) -> void:
	var positions = _Tile._get_coords(tile)
	var x = remove as int
	assert(positions, "ERROR: Unexpected tile axis when positioning")
	var value = 0 if remove else tile.axis
	for pos in positions:
		grid[pos.y][pos.x] = value
#
#static func _print_grid(grid: Array[PackedByteArray]) -> void:
	#for row in grid:
		#print(row)
