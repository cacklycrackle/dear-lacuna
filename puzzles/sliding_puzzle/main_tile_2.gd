extends BaseTile
class_name main_tile_2


@onready var _m_area = $MainArea
@onready var _m_collider = $MainArea/CollisionShape2D


func _init() -> void:
	queries = {
		"left": [PhysicsShapeQueryParameters2D.new(), Vector2(-60, 0)],
		"right": [PhysicsShapeQueryParameters2D.new(), Vector2(60, 0)]
	}
	axis = AxisType.X

func _ready() -> void:
	$Sprite2D.scale = Vector2(0.9375, 0.9375)
	_tile_area = _m_area
	_tile_collider = _m_collider
	super._ready()
