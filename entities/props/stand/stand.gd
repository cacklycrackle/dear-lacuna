extends Sprite2D


signal started
signal solved

var interactable = false
var puzzle_base = null
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
		started.emit() # to handle any puzzle-specific settings
		puzzle.solved.connect(_on_puzzle_solved)
		puzzle.exited.connect(_on_puzzle_exited)
		add_child(puzzle)
		GameManager.in_puzzle = true

func _on_puzzle_solved() -> void:
	puzzle.queue_free()
	GameManager.in_puzzle = false
	solved.emit()

func _on_puzzle_exited() -> void:
	puzzle.queue_free()
	await get_tree().process_frame
	GameManager.in_puzzle = false
