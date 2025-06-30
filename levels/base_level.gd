extends Node2D
class_name BaseLevel


var level_id: int
var save_name: String
var stands_solved: Array[bool]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_name = name.to_snake_case()
