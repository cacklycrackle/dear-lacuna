extends Node2D

@onready var hand_cursor = $HandCursor
@onready var l_line: Line2D = $LeftLine
@onready var r_line: Line2D = $RightLine
@onready var center: Vector2 = $Center.global_position
@export var _rock_scene = preload("res://puzzles/slingshot_puzzle/rock/rock.tscn")

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
	hand_cursor.speed = 200.0
	hand_cursor.global_position = center

func _process(delta: float) -> void:
	match _state:
		SlingState.IDLE:
			pass
		SlingState.PULLING:
			var pos = hand_cursor.global_position
			if Input.is_action_pressed("interact"):
				# Slingshot pulled back
				if pos.distance_to(center) > 75:
					pos = center + (pos - center).normalized() * 75
				rock.global_position = pos
				_set_lines(pos)
			else:
				# Rock launched
				hand_cursor.moveable = false
				var distance = pos.distance_to(center)
				var velocity = center - pos
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
				hand_cursor.global_position = center
func _set_lines(loc: Vector2) -> void:
	l_line.points[1] = l_line.to_local(loc)
	r_line.points[1] = r_line.to_local(loc)

func _spawn_new_rock() -> void:
	rock = _rock_scene.instantiate()
	add_child(rock)
	rock.global_position = center

func _input(event: InputEvent) -> void:
	if _state == SlingState.IDLE and not rock.is_thrown and Input.is_action_pressed("interact"):
		_state = SlingState.PULLING
		hand_cursor.moveable = true
