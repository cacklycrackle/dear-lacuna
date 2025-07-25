extends CanvasLayer


signal solved
signal exited

const _descr = """[b][color=BLACK]Objective[/color][/b]: Unleash the rock unto the numbered targets [u]in ascending order[/u]
[ul] While engaging thine [color=#065084]interact key[/color]([i]default[/i]: Z), employ [/ul]
[indent]   thy [color=#065084]movement keys[/color] to guide the hand cursor around[/indent]
[ul] Release thine [color=#065084]interact key[/color] to launch the rock upon its fateful path[/ul]
[ul] Bide thy time until the rock doth rematerialise on the slingshot[/ul]
"""
@onready var slingshot = $Slingshot

enum PuzzleState {
	PLAY,
	WIN
}
var _state: PuzzleState

var _number = 1
var _targets: Array[Node]


func _ready() -> void:
	# Scale puzzle down to 3/4 of screen size
	#var orig_size = get_viewport().get_visible_rect().size
	#scale = Vector2(0.75, 0.75)
	#offset = (Vector2(1.0, 1.0) - scale) * orig_size / 2
	
	_targets = get_tree().get_nodes_in_group("target_to_hit")
	var numbers = range(1, _targets.size() + 1)
	numbers.shuffle()
	for i in range(numbers.size()):
		var x = numbers[i]
		_targets[i].number = x
		_targets[i].area.body_entered.connect(_on_target_entered.bind(i, x))
	_state = PuzzleState.PLAY

func _on_target_entered(body: Node2D, index: int, value: int) -> void:
	if body == slingshot.rock and _targets[index].visible:
		if value == _number:
			#_targets[index].color = Color.PALE_GREEN
			_targets[index].visible = false
			_number += 1

func _process(_delta: float) -> void:
	match _state:
		PuzzleState.PLAY:
			if _number == _targets.size() + 1:
				_state = PuzzleState.WIN
		PuzzleState.WIN:
			solved.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		exited.emit()
	elif event.is_action_pressed("puzzle_help"):
		GlobalPopup.show_help(_descr)
