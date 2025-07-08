extends CanvasLayer


signal solved
signal exited

const AXIS = BaseTile.AxisType
var _puzzle_board = preload("res://common/sliding_puzzle/puzzle_board.tscn")
var _cursor_scene = preload("res://common/sliding_puzzle/hand_cursor/hand_cursor.tscn")
var _tile_dict = {
	AXIS.X: preload("res://common/sliding_puzzle/tiles/horizontal_tile/horizontal_tile.tscn"),
	AXIS.Y: preload("res://common/sliding_puzzle/tiles/vertical_tile/vertical_tile.tscn"),
	AXIS.M: preload("res://common/sliding_puzzle/tiles/main_tile/main_tile.tscn"),
}
var _screen_center

#var offset = Vector2.ZERO
var tile_location


func _ready() -> void:
	_screen_center = get_viewport().get_visible_rect().size / 2 - offset
	
	var puzzle_scene = _puzzle_board.instantiate()
	var sprite = puzzle_scene.get_node("Sprite2D")
	sprite.scale = Vector2(0.9375, 0.9375)
	puzzle_scene.global_position = _screen_center
	puzzle_scene.get_node("End").area_entered.connect(_on_puzzle_end_entered)
	add_child(puzzle_scene)
	
	_inst_at_middle(_cursor_scene)
	_inst_all_tiles()

func _on_puzzle_end_entered(area: Area2D):
	if area.get_parent() is MainTile:
		solved.emit()

func _inst_at_middle(scene):
	var child = scene.instantiate()
	child.global_position = _screen_center
	add_child(child)

func _inst_all_tiles():
	for i in tile_location:
		for pos in tile_location[i]:
			#_inst_tile(pos[0], pos[1], _tile_dict[i])
			_inst_tile(pos, _tile_dict[i])

#func _inst_tile(x, y, tile):
func _inst_tile(p: Vector2i, tile: Resource) -> void:
	var child = tile.instantiate()
	match child.axis:
		BaseTile.AxisType.X:
			#child.global_position = _screen_center + Vector2(x * 60, -y * 60 + 30)
			child.global_position = _screen_center\
									+ Vector2(60 * (p.x - 2), 30 - 60 * (3 - p.y))
		BaseTile.AxisType.Y:
			#child.global_position = _screen_center + Vector2(x * 60 - 30, -y * 60 + 60)
			child.global_position = _screen_center\
									+ Vector2(60 * (p.x - 2) - 30, 60 - 60 * (3 - p.y))
		BaseTile.AxisType.M:
			#child.global_position = _screen_center + Vector2(p.x * 60 - 30, -p.y * 60 + 30)
			child.global_position = _screen_center\
									+ Vector2(60 * (p.x - 2) - 30, 30 - 60 * (3 - p.y))
	add_child(child)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		exited.emit()
