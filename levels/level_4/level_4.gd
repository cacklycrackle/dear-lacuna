extends BaseLevel


func _ready() -> void:
	super._ready()
	level_id = 4
	
	$Stand1.puzzle_base = preload("res://puzzles/slingshot_puzzle/puzzle_base.tscn")
	$Stand1.solved.connect(_on_puzzle_solved.bind(1))
	stands_solved.resize(1)
	for i in range(1, stands_solved.size() + 1):
		if GameManager.save_data[save_name]["stand_%d" % i]:
			_on_puzzle_solved(i)
	
	GameManager.spawn_player(self)
	VisionManager.init_vision_for_level()

func _on_puzzle_solved(stand: int) -> void:
	if stands_solved[stand - 1]: return
	var wall := get_node("Stand%d/LockedLayer" % stand)
	wall.collision_enabled = false
	wall.visible = false
	stands_solved[stand - 1] = true
	GameManager.save_data[save_name]["stand_%d" % stand] = true
