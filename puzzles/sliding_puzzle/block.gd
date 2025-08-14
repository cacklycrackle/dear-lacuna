extends BaseTile

func _init() -> void:
	axis = AxisType.M

func _ready() -> void:
	$Sprite2D.scale = Vector2(0.9375, 0.9375)
	super._ready()
