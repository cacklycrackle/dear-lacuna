extends Node2D


signal solved
signal exited


var sliding_puzzle = preload("res://common/sliding_puzzle/sliding_puzzle.tscn")
var cursor = preload("res://common/sliding_puzzle/hand_cursor/hand_cursor.tscn")
var tile_2_v = preload("res://common/sliding_puzzle/tiles/vertical_tile/vertical_tile.tscn")
var tile_2_h = preload("res://common/sliding_puzzle/tiles/horizontal_tile/horizontal_tile.tscn")
var main_tile = preload("res://common/sliding_puzzle/tiles/main_tile/main_tile.tscn")
var screen_center

var offset = Vector2.ZERO
var tile_location # = [[0,0,"m"], [-2,1,"h"]]
var tile_dict = {"v2" : tile_2_v, "h2" : tile_2_h, "m" : main_tile}


func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2 - offset
	
	var puzzle_scene = sliding_puzzle.instantiate()
	var sprite = puzzle_scene.get_node("Sprite2D")
	sprite.scale = Vector2(0.9375, 0.9375)
	puzzle_scene.global_position = screen_center
	puzzle_scene.get_node("End") \
	  .area_entered \
	  .connect(func(_area: Area2D): solved.emit())
	add_child(puzzle_scene)
	
	inst_at_middle(cursor)
	inst_all_tiles()

func inst_at_middle(scene):
	var child = scene.instantiate()
	child.global_position = screen_center
	add_child(child)

func inst_all_tiles():
	for i in tile_location:
		for j in tile_location[i]:
			inst_tile(j[0], j[1], tile_dict[i])

func inst_tile(x, y, tile):
	var child = tile.instantiate()
	if child.axis == "x":
		child.global_position = screen_center + Vector2(x * 60 - 30, -y * 60)
	elif child.axis == "m":
		child.global_position = screen_center + Vector2(x * 60 - 30, -y * 60 + 30)
	else:
		child.global_position = screen_center + Vector2(x * 60, -y * 60 + 30)
	add_child(child)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		exited.emit()
