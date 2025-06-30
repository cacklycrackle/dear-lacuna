extends Control

@onready var selection = $VBoxContainer/HBoxContainer
@onready var highlight = $Highlight
var index = 0
var saves
const _SAVE_FILE_PATH = "user://Saves"
var save_path

func _ready() -> void:
	await get_tree().process_frame
	saves = selection.get_children()
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
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		queue_free()

func press():
	saves[index].pressed.emit()
	for node in get_tree().root.get_children():
		if node is BaseLevel:
			GameManager.save_data["position"] = node.get_node("Player").global_position
			GameManager.save_data["level"] = node.level_id
			GameManager.save_data["first_start"] = false
	
	var json = JSON.stringify(GameManager.save_data)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json)
	file.close()
	
	get_tree().paused = false
	queue_free()

func _on_save_1_pressed() -> void:
	save_path = _SAVE_FILE_PATH + "/Save1.json"

func _on_save_2_pressed() -> void:
	save_path = _SAVE_FILE_PATH + "/Save2.json"

func _on_save_3_pressed() -> void:
	save_path = _SAVE_FILE_PATH + "/Save3.json"
