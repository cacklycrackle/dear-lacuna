extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background.size = get_viewport_rect().size
