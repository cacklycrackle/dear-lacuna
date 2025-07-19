extends Node2D

@onready var l_line: Line2D = $LeftLine
@onready var r_line: Line2D = $RightLine
@onready var center: Vector2 = $Center.global_position
@export var _rock_scene = preload("res://common/slingshot_puzzle/rock/rock.tscn")

enum SlingState {
	IDLE,
	PULLING,
	SHOT,
	RESET
}
var _state: SlingState
var rock: Rock


func _ready() -> void:
	_state = SlingState.IDLE
	_set_lines(center)
	_spawn_new_rock()

func _process(_delta: float) -> void:
	match _state:
		SlingState.IDLE:
			pass
		SlingState.PULLING:
			var mouse = get_global_mouse_position()
			if Input.is_action_pressed("interact"):
				# Slingshot pulled back
				if mouse.distance_to(center) > 75:
					mouse = center + (mouse - center).normalized() * 75
				rock.global_position = mouse
				_set_lines(mouse)
			else:
				# Rock launched
				var distance = rock.global_position.distance_to(center)
				var velocity = center - rock.global_position
				rock.throw_rock(velocity / 5 * distance)
				_set_lines(center)
				_state = SlingState.SHOT
		SlingState.SHOT:
			# Despawn rock once it has stopped
			if is_instance_valid(rock) and not rock.is_thrown:
				_state = SlingState.RESET
				rock.queue_free()
				rock = null
		SlingState.RESET:
			# Respawn a new rock on slingshot
			if not is_instance_valid(rock):
				_state = SlingState.IDLE
				_set_lines(center)
				_spawn_new_rock()
func _set_lines(loc: Vector2) -> void:
	l_line.points[1] = l_line.to_local(loc)
	r_line.points[1] = r_line.to_local(loc)

func _spawn_new_rock() -> void:
	rock = _rock_scene.instantiate()
	add_child(rock)
	rock.global_position = center

func _on_touch_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _state == SlingState.IDLE and not rock.is_thrown:
		if (event is InputEventMouseMotion) and Input.is_action_pressed("interact"):
			_state = SlingState.PULLING
