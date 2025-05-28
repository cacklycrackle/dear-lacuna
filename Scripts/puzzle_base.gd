extends Node2D

var puzzle_scene = preload("res://Scenes/sliding_puzzle.tscn")
var cusor = preload("res://Scenes/hand_cursor.tscn")
var tile_2_up = preload("res://Scenes/sliding_tile_2_up.tscn")
var tile_2_right = preload("res://Scenes/sliding_tile_2_right.tscn")
var screen_center
var offset = Vector2.ZERO
var tile_location = [[1,1,"2r"], [-2,1,"2u"]]
var tile_dict = {"2u" : tile_2_up, "2r" : tile_2_right}

func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2 - offset
	int_at_middle(puzzle_scene)
	int_at_middle(cusor)
	int_all_tiles()
	

func int_at_middle(scene):
	var child = scene.instantiate()
	child.global_position = screen_center
	add_child(child)

func int_all_tiles():
	for i in tile_location:
		int_tile(i[0], i[1], tile_dict[i[2]])

func int_tile(x, y, tile):
	var child = tile.instantiate()
	if child.axis == "x":
		child.global_position = screen_center + Vector2(x * 60 + 30, -y * 60)
	else:
		child.global_position = screen_center + Vector2(x * 60, -y * 60 -30)
	add_child(child)
	
	
	
