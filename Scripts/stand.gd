extends Sprite2D

@onready var animation = $AnimationPlayer

var interactable = false
var puzzle_tiles = []
var puzzle_base = preload("res://Scenes/puzzle_base.tscn")
var puzzle
var solved :bool = false: set = set_solved

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactable and not GameManager.in_puzzle:
		puzzle = puzzle_base.instantiate()
		puzzle.tile_location = puzzle_tiles
		puzzle.offset = global_position
		add_child(puzzle)
		GameManager.in_puzzle = true

func set_solved(v):
	print(v)
	call_deferred("remove_child", puzzle)
	GameManager.in_puzzle = false
	
