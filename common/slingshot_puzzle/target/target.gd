extends Node2D


@onready var label = $Label
@onready var area = $Area2D

var number: int:
	set(value):
		number = value
		_update_label_text()
var color: Color:
	set(value):
		color = value
		_update_label_color()


func _ready() -> void:
	color = Color.SALMON
	label.pivot_offset = label.size / 2

func _update_label_text():
	if is_instance_valid(label):
		label.text = str(number)
	else:
		print("ERROR: label not found")

func _update_label_color():
	if is_instance_valid(label):
		label.set("theme_override_colors/font_color", color)
	else:
		print("ERROR: label not found")
