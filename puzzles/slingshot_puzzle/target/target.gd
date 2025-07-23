extends Node2D


@onready var _label = $Label
@onready var area = $TargetArea

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
	_label.pivot_offset = _label.size / 2

func _update_label_text():
	if is_instance_valid(_label):
		_label.text = str(number)
	else:
		print("ERROR: label not found")

func _update_label_color():
	if is_instance_valid(_label):
		_label.set("theme_override_colors/font_color", color)
	else:
		print("ERROR: label not found")
