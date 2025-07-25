extends Control


@onready var selection = $VBoxContainer/HBoxContainer
@onready var highlight = $Highlight
@onready var pause_menu = load("res://common/ui/pause_menu/pause_menu.tscn")

var _index: int = 0:
	set(value):
		_index = value
		_update_sel()
var saves: Array[Node] = []
const _SAVE_DIR = "user://Saves"


func _ready() -> void:
	await get_tree().process_frame
	var all_saves = selection.get_children()
	for i in range(len(all_saves)):
		var check = "%s/Save%d.json" % [_SAVE_DIR, i + 1]
		if FileAccess.file_exists(check):
			saves.append(all_saves[i])
		else:
			all_saves[i].add_theme_color_override("font_color", Color(1,0,0))
	
	_update_sel()
	highlight.size = saves[0].size + Vector2(10, 10)

func _update_sel():
	highlight.global_position = saves[_index].global_position - Vector2(5, 5)

func _input(event):
	if event.is_action_pressed("right"):
		_index = (_index + 1) % saves.size()
	elif event.is_action_pressed("left"):
		_index = (_index - 1) % saves.size()
	elif event.is_action_pressed("ui_accept"): # Enter key
		_press()
	elif event.is_action_pressed("pause"):
		if self.get_parent() is Window:
			set_process_input(false)
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0.0, 0.5)
			await tween.finished
			get_tree().change_scene_to_file("res://common/ui/start_menu/start_menu.tscn")
		elif self.get_parent() is CanvasLayer:
			var pause_menu_inst = pause_menu.instantiate()
			get_tree().paused = true
			self.get_parent().queue_free()
			var top_layer = CanvasLayer.new()
			top_layer.layer = 1
			get_tree().root.add_child(top_layer)
			get_tree().paused = true
			pause_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
			top_layer.add_child(pause_menu_inst)

func _press():
	var save_path = "{0}/{1}.json".format([_SAVE_DIR, saves[_index].name])
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	_load_data(data)

func _load_data(data):
	for i in data:
		GameManager.save_data[i] = data[i]
	GameManager.load_from_save = true
	var level = int(GameManager.save_data["level"])
	var load_scene = "res://levels/level_{0}/level_{0}.tscn".format([level])
	set_process_input(false)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	#print(self.get_parent())
	if self.get_parent() is CanvasLayer:
		self.get_parent().queue_free()
	get_tree().change_scene_to_file(load_scene)
	#if get_tree():
		#print(get_tree().root.get_children())


	
