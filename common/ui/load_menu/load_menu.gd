extends Control
@onready var selection = $VBoxContainer/HBoxContainer
@onready var highlight = $Highlight
var index = 0
var saves = []
const _SAVE_FILE_PATH = "user://Saves"
var save_path
func _ready() -> void:
	await get_tree().process_frame
	var all_saves = selection.get_children()
	for i in range(len(all_saves)):
		var check = _SAVE_FILE_PATH + "/Save" + str(i + 1) + ".json"
		if FileAccess.file_exists(check):
			saves.append(all_saves[i])
		else:
			all_saves[i].add_theme_color_override("font_color", Color(1,0,0))
	print(saves)
	highlight.global_position = saves[0].global_position - Vector2(5, 5)
	highlight.size = saves[0].size + Vector2(10, 10)
	
func update_sel():
	highlight.global_position = saves[index].global_position - Vector2(5, 5)

func _input(event):
	if event.is_action_pressed("right"):
		index = (index + 1) % saves.size()
		update_sel()
	elif event.is_action_pressed("left"):
		index = (index - 1) % saves.size()
		update_sel()
	elif event.is_action_pressed("ui_accept"): # Enter key
		press()
func press():
	saves[index].pressed.emit()
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	load_data(data)

func _on_save_1_pressed():
	save_path =  _SAVE_FILE_PATH + "/Save1.json"
	
func _on_save_2_pressed():
	save_path = _SAVE_FILE_PATH + "/Save2.json"
	
func _on_save_3_pressed():
	save_path = _SAVE_FILE_PATH + "/Save3.json"

func load_data(data):
	for i in data:
		GameManager.save_data[i] = data[i]
	GameManager.load_from_save = true
	var num_str =  str(int(GameManager.save_data["level"]))
	var load_scene = "res://levels/level_" + num_str + "/level_" + num_str + ".tscn"
	
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file(load_scene)
