extends BaseTile


@onready var _v_area = $VerticalArea
@onready var _v_collider = $VerticalArea/CollisionShape2D


func _init() -> void:
	queries = {
		"up": [PhysicsShapeQueryParameters2D.new(), Vector2(0, -60)],
		"down": [PhysicsShapeQueryParameters2D.new(), Vector2(0, 60)],
	}
	axis = AxisType.Y

func _ready() -> void:
	$Sprite2D.scale = Vector2(0.9375, 0.9375)
	_tile_area = _v_area
	_tile_collider = _v_collider
	super._ready()
