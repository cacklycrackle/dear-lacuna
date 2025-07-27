extends Sprite2D


signal started
signal solved

var interactable: bool = false
var puzzle_base: Resource = null
var puzzle: Node = null
var is_solved = false


func _ready():
	self.frame = 0
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.collision_layer == 1: 
		GameManager.vision_bool = false
		var bg_nodes = get_tree().get_nodes_in_group(VisionManager.BG_GROUP_NAME)
		for node in bg_nodes:
			if node is CanvasItem:
				var vision = node.material
				if vision is ShaderMaterial:
					if vision.get_shader_parameter("radius") < 50:
						vision.set_shader_parameter("radius", 50)
						vision.set_shader_parameter("player_pos", self.global_position)
		#if not solved_bool:
			#interactable = true
		interactable = not is_solved
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.collision_layer == 1:
		interactable = false
		GameManager.vision_bool = true
	
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
	_complete_state()
	GameManager.in_puzzle = false
	solved.emit()

func _complete_state() -> void:
	is_solved = true
	$AnimationPlayer.play("Complete")

func _on_puzzle_exited() -> void:
	puzzle.queue_free()
	await get_tree().process_frame
	GameManager.in_puzzle = false
