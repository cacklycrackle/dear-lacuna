extends BaseTile


func _init() -> void:
	queries = {
		"left": [PhysicsPointQueryParameters2D.new(), Vector2(-60, 0)],
		"right": [PhysicsPointQueryParameters2D.new(), Vector2(60, 0)],
	}
	axis = AxisType.Y

func _ready() -> void:
	$Sprite2D.scale = Vector2(0.9375, 0.9375)
	for dir in queries:
		var q = queries[dir]
		q[0].position = global_position + 1.5 * q[1]
		q[0].collision_mask = 4
		q[0].collide_with_areas = true

func try_move(event: InputEvent) -> bool:
	for dir in queries:
		if event.is_action_pressed(dir):
			cursor.moveable = false
			var q = queries[dir]
			if space_state.intersect_point(q[0]).size() == 0:
				global_position += q[1]
				return true
	return false
