extends BaseTile
class_name MainTile


@onready var _m_area = $MainArea
@onready var _m_collider = $MainArea/CollisionShape2D


func _init() -> void:
	queries = {
		"left": [PhysicsShapeQueryParameters2D.new(), Vector2(-60, 0)],
		"right": [PhysicsShapeQueryParameters2D.new(), Vector2(60, 0)],
		"up": [PhysicsShapeQueryParameters2D.new(), Vector2(0, -60)],
		"down": [PhysicsShapeQueryParameters2D.new(), Vector2(0, 60)],
	}
	axis = AxisType.M

func _ready() -> void:
	_tile_area = _m_area
	_tile_collider = _m_collider
	super._ready()
