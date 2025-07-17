extends Node2D
class_name BaseTile


@onready var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

var _tile_area: Area2D
var _tile_collider: CollisionShape2D
var _moveable: bool = false
var queries: Dictionary[String, Array] 
# string one of [up, down, left, right], array of the form [PhysicsShapeQueryParameters2D, Vector2]
var cursor: HandCursor
enum AxisType {M = 1, X, Y}
var axis: AxisType


func _ready() -> void:
	if not is_instance_valid(_tile_area) or not is_instance_valid(_tile_collider):
		return
	
	_tile_area.area_entered.connect(_on_area_2d_area_entered)
	_tile_area.area_exited.connect(_on_area_2d_area_exited)
	for dir in queries:
		var q = queries[dir]
		q[0].collision_mask = 0b100
		q[0].collide_with_areas = true

func _input(event: InputEvent) -> void:
	if _moveable and Input.is_action_pressed("interact"):
		if _try_move(event):
			cursor.global_position = global_position
	
	if event.is_action_released("interact") and cursor:
		cursor.moveable = true

func _try_move(event: InputEvent) -> bool:
	for dir in queries:
		if event.is_action_pressed(dir):
			cursor.moveable = false
			var q = queries[dir]
			var intended_pos = global_position + q[1]
			q[0].shape = _tile_collider.shape
			q[0].transform = Transform2D(0, intended_pos + _tile_area.position)
			q[0].exclude = [_tile_area]
			
			var result = space_state.intersect_shape(q[0])
			if result.size() == 0:
				global_position = intended_pos
				return true
			#for hit in result:
				#print("- Collider: %s, Layer: %d" % [hit.collider.name, hit.collider.collision_layer])
	return false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is HandCursor:
		cursor = area.get_parent()
		_moveable = true

func _on_area_2d_area_exited(_area: Area2D) -> void:
	if cursor:
		cursor = null
		_moveable = false
