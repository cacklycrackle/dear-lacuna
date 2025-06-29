extends CanvasLayer


signal solved
signal exited

@onready var slingshot = $Slingshot

enum PuzzleState {
	PLAY,
	WIN
}
var state: PuzzleState

var number = 1
var screen_center: Vector2
var targets: Array[Node]


func _ready() -> void:
	var orig_size = get_viewport().get_visible_rect().size
	scale = Vector2(0.75, 0.75)
	offset = (Vector2(1.0, 1.0) - scale) * orig_size / 2
	
	targets = get_tree().get_nodes_in_group("target_to_hit")
	var numbers = range(1, targets.size() + 1)
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

func _process(_delta: float) -> void:
	match state:
		PuzzleState.PLAY:
			if number == targets.size() + 1:
				state = PuzzleState.WIN
		PuzzleState.WIN:
			solved.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		exited.emit()
