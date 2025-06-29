extends CanvasLayer


signal solved
signal exited


var _puzzle_board = preload("res://common/sliding_puzzle/puzzle_board.tscn")
var _cursor_scene = preload("res://common/sliding_puzzle/hand_cursor/hand_cursor.tscn")
var tile_v2 = preload("res://common/sliding_puzzle/tiles/vertical_tile/vertical_tile.tscn")
var tile_h2 = preload("res://common/sliding_puzzle/tiles/horizontal_tile/horizontal_tile.tscn")
var main_tile = preload("res://common/sliding_puzzle/tiles/main_tile/main_tile.tscn")
var _screen_center

#var offset = Vector2.ZERO
var tile_location # = [[0,0,"m"], [-2,1,"h"]]
var _tile_dict = {"v2" : tile_v2, "h2" : tile_h2, "m" : main_tile}


func _ready() -> void:
	_screen_center = get_viewport().get_visible_rect().size / 2 - offset
	
	var puzzle_scene = _puzzle_board.instantiate()
	var sprite = puzzle_scene.get_node("Sprite2D")
	sprite.scale = Vector2(0.9375, 0.9375)
	puzzle_scene.global_position = _screen_center
	#puzzle_scene.get_node("End") \
	  #.area_entered \
	  #.connect(func(_area: Area2D): solved.emit())
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
