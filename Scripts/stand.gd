extends Sprite2D

@onready var animation = $AnimationPlayer

var interactable = false
var puzzle_tiles = []
var puzzle_base = preload("res://Scenes/puzzle_base.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactable and not GameManager.in_puzzle:
		print("spawn")
		var puzzle = puzzle_base.instantiate()
		puzzle.tile_location = puzzle_tiles
		puzzle.offset = global_position
		add_child(puzzle)
		GameManager.in_puzzle = true
		
	
