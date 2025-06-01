extends Sprite2D


var interactable = false
#var puzzle_tiles = []
var puzzle_tiles_dict = {
	"v" : Vector2(-2, 1),
	"h" : Vector2(1, 1),
	"m" : Vector2(2, 2),
}
var puzzle_base = preload("res://levels/level_02/sliding_puzzle/puzzle_base.tscn")
var puzzle = null


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactable and not GameManager.in_puzzle:
		puzzle = puzzle_base.instantiate()
		puzzle.tile_location = puzzle_tiles_dict
		puzzle.offset = global_position
		puzzle.solved.connect(_on_puzzle_solved)
		add_child(puzzle)
		GameManager.in_puzzle = true

func _on_puzzle_solved() -> void:
	puzzle.queue_free()
	# call_deferred("remove_child", puzzle)
	GameManager.in_puzzle = false
