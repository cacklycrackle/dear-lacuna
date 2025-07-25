extends Control


@onready var selection = $VBoxContainer/HBoxContainer
@onready var help = $VBoxContainer/ErrorPanelContainer
@onready var pause_menu = load("res://common/ui/pause_menu/pause_menu.tscn")
@onready var la = $LeftArrow
@onready var ra = $RightArrow

var _index: int = 0:
	set(value):
		_index = value
		_update_sel()
var saves: Array[Node] = []
const _SAVE_DIR = "user://Saves"


func _ready() -> void:
	$LeftArrow/LeftAnimation.play("Default")
	$RightArrow/RightAnimation.play("Default")
	var all_saves = selection.get_children()
	for i in range(all_saves.size()):
		var check = "%s/Save%d.json" % [_SAVE_DIR, i + 1]
		if FileAccess.file_exists(check):
			saves.append(all_saves[i])
		else:
			all_saves[i].disabled = true
	call_deferred("_update_sel")

func _update_sel():
	var pos = saves[_index].global_position
	la.global_position = pos + Vector2(-45, saves[0].size.y/2)
	ra.global_position = pos + Vector2(45 + saves[0].size.x, saves[0].size.y/2)

func _input(event):
	if event.is_action_pressed("right"):
		_index = (_index + 1) % saves.size()
	elif event.is_action_pressed("left"):
		_index = (_index - 1) % saves.size()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"): # Enter key
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
			top_layer.layer = 2
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

func _load_data(data: Dictionary) -> void:
	GameManager.load_from_save = true
	
	for i in GameManager.save_data:
		if data.has(i) and data[i] != null:
			GameManager.save_data[i] = data[i]
		else:
			_show_help()
			return
	_hide_help()
	GameManager.save_data["position"] = str_to_var("Vector2" + data["position"])
	var level = int(data["level"])
	if level <= 0 or level > GameManager.NO_OF_LEVELS:
		_show_help()
		return
	GameManager.save_data["level"] = level
	GameManager.curr_level_no = level
	
	set_process_input(false)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	#print(self.get_parent())
	if self.get_parent() is CanvasLayer:
		self.get_parent().queue_free()
	GameManager.load_level()

func _show_help() -> void:
	%ErrorLabel.text = "Tried to load invalid save. Resave to load game."
	help.visible = true

func _hide_help() -> void:
	%ErrorLabel.text = ""
	help.visible = false
