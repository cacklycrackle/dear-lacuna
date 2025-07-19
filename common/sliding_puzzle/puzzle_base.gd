extends CanvasLayer


signal solved
signal exited

const _descr = """[b][color=#074799]Objective[/color][/b]: Transport the [i]principal ocular tile[/i] 
unto the designated square upon the rightward side
[ul] Employ thy [color=#065084]movement keys[/color] ([i]default[/i]: arrow keys) to[/ul]
[indent]   guide thy hand cursor o'er tile to shift henceforth[/indent]
[ul] With thy cursor in position, hold the [color=#065084]interact key[/color] ([i]default[/i]: Z)[/ul]
[indent]   and [color=#065084]movement keys[/color] in unison to nudge a tile most moveable[/indent]
"""
var _puzzle_board = preload("res://common/sliding_puzzle/puzzle_board.tscn")
var _cursor_scene = preload("res://common/sliding_puzzle/hand_cursor/hand_cursor.tscn")
var _tile_dict = {
	"v2": preload("res://common/sliding_puzzle/tiles/vertical_tile/vertical_tile.tscn"),
	"h2": preload("res://common/sliding_puzzle/tiles/horizontal_tile/horizontal_tile.tscn"),
	"m": preload("res://common/sliding_puzzle/tiles/main_tile/main_tile.tscn"),
}
var _screen_center: Vector2
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
		for j in tile_location[i]:
			_inst_tile(j[0], j[1], _tile_dict[i])

func _inst_tile(x, y, tile):
	var child = tile.instantiate()
	match child.axis:
		BaseTile.AxisType.X:
			child.global_position = _screen_center + Vector2(x * 60 - 30, -y * 60)
		BaseTile.AxisType.Y:
			child.global_position = _screen_center + Vector2(x * 60, -y * 60 + 30)
		BaseTile.AxisType.M:
			child.global_position = _screen_center + Vector2(x * 60 - 30, -y * 60 + 30)
	add_child(child)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		exited.emit()
	elif event.is_action_pressed("puzzle_help"):
		GlobalPopup.show_help(_descr)
