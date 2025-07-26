extends Control


@onready var selection = $VBoxContainer/HBoxContainer
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
	saves = selection.get_children()
	var ini = Vector2(153.0, 281.0)
	la.global_position = ini + Vector2(-45, 33/2)
	ra.global_position = ini + Vector2(45 + 115, 33/2)
	$LeftArrow/LeftAnimation.play("Default")
	$RightArrow/RightAnimation.play("Default")


	
func _update_sel():
	var ini = saves[_index].global_position

	la.global_position = ini + Vector2(-45, 33/2)
	ra.global_position = ini + Vector2(45 + 115, 33/2)
	#highlight.global_position = saves[_index].global_position - Vector2(5, 5)

func _input(event):
	if event.is_action_pressed("right"):
		_index = (_index + 1) % saves.size()
	elif event.is_action_pressed("left"):
		_index = (_index - 1) % saves.size()
	elif event.is_action_pressed("ui_accept"): # Enter key
		press()
		GameManager.is_paused = false
	elif event.is_action_pressed("pause"):
		var pause_menu_inst = pause_menu.instantiate()
		get_tree().paused = true
		self.get_parent().queue_free()
		var top_layer = CanvasLayer.new()
		top_layer.layer = 1
		get_tree().root.add_child(top_layer)
		get_tree().paused = true
		pause_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
		top_layer.add_child(pause_menu_inst)


func press():
	for node in get_tree().root.get_children():
		if node is BaseLevel:
			GameManager.save_data["position"] = node.get_node("Player").global_position
			GameManager.save_data["level"] = node.level_id
			GameManager.save_data["first_start"] = false
	var json = JSON.stringify(GameManager.save_data)
	
	var save_path = "{0}/{1}.json".format([_SAVE_DIR, saves[_index].name])
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json)
	file.close()
	
	get_tree().paused = false
	self.get_parent().queue_free()
