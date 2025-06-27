extends Node2D
class_name BaseTile


@onready var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

var _moveable: bool = false
var queries: Dictionary[String, Array] 
# string one of [up, down, left, right], array of the form [PhysicsPointQueryParameters2D, Vector2]
var cursor: HandCursor
enum AxisType {X, Y, M}
var axis: AxisType


func _input(event: InputEvent) -> void:
	if _moveable and Input.is_action_pressed("interact"):
		var initial_pos = global_position
		if try_move(event):
			var delta = global_position - initial_pos
			for s in queries:
				queries[s][0].position += delta
			cursor.global_position = global_position
	
	if event.is_action_released("interact") and cursor:
		cursor.moveable = true

func try_move(event: InputEvent) -> bool:
	return false

func _on_area_2d_area_entered(area: Area2D) -> void:
	cursor = area.get_parent()
	_moveable = true

func _on_area_2d_area_exited(_area: Area2D) -> void:
	_moveable = false
