extends Node2D

@onready var slingshot = $Slingshot

enum PuzzleState {
	PLAY,
	WIN
}
var state: PuzzleState

var start = 1
var number = start
var screen_center: Vector2
var targets: Array[Node]


func _ready() -> void:
	targets = get_tree().get_nodes_in_group("target_to_hit")
	var numbers = range(start, targets.size() + start)
	numbers.shuffle()
	for i in range(numbers.size()):
		var x = numbers[i]
		targets[i].number = x
		targets[i].area.body_entered.connect(_on_target_entered.bind(i, x))
	state = PuzzleState.PLAY

func _on_target_entered(body: Node2D, index: int, value: int) -> void:
	if body == slingshot.rock and targets[index].visible:
		if value == number:
			#targets[index].color = Color.PALE_GREEN
			targets[index].visible = false
			number += 1
		else:
			for target in targets:
				target.color = Color.SALMON
				target.visible = true
			number = 1

func _process(delta: float) -> void:
	match state:
		PuzzleState.PLAY:
			if number == targets.size() + start + 1:
				state = PuzzleState.WIN
		PuzzleState.WIN:
			queue_free()
