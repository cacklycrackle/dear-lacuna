extends BaseTile


@onready var _h_area = $HorizontalArea
@onready var _h_collider = $HorizontalArea/CollisionShape2D


func _init() -> void:
	queries = {
		"left": [PhysicsShapeQueryParameters2D.new(), Vector2(-60, 0)],
		"right": [PhysicsShapeQueryParameters2D.new(), Vector2(60, 0)],
	}
	axis = AxisType.Y

func _ready() -> void:
	$Sprite2D.scale = Vector2(0.9375, 0.9375)
	_tile_area = _h_area
	_tile_collider = _h_collider
	super._ready()
