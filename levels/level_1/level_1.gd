extends BaseLevel


@onready var f = load("res://common/assets/fonts/yoster.ttf")
const _actions = ["up", "down", "left", "right", "interact", "pause"]


func _init() -> void:
	level_id = 1

func _ready() -> void:
	super._ready()
	for i in range(_actions.size()):
		var name_label := Label.new()
		name_label.add_theme_font_override("font", f)
		name_label.add_theme_font_size_override("font_size", 16)
		name_label.text = _actions[i]
		%HelpGridContainer.add_child(name_label)
		
		var events := InputMap.action_get_events(_actions[i])
		assert(events.size() > 0)
		var act_label := Label.new()
		act_label.add_theme_font_override("font", f)
		act_label.add_theme_font_size_override("font_size", 16)
		act_label.text = events[0].as_text().trim_suffix(" (Physical)")
		%HelpGridContainer.add_child(act_label)
