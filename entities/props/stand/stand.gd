extends Sprite2D


var interactable = false
#var puzzle_tiles = []
var puzzle_tiles_dict = {}
var puzzle_base = preload("res://common/sliding_puzzle/puzzle_base.tscn")
var puzzle = null

signal solved


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
		puzzle.exited.connect(_on_puzzle_exited)
		add_child(puzzle)
		GameManager.in_puzzle = true

func _on_puzzle_solved() -> void:
	puzzle.queue_free()
	# call_deferred("remove_child", puzzle)
	GameManager.in_puzzle = false
	solved.emit()

func _on_puzzle_exited() -> void:
	puzzle.queue_free()
	await get_tree().process_frame
	GameManager.in_puzzle = false
