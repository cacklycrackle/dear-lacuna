extends Control


@onready var pause_menu = load("res://common/ui/pause_menu/pause_menu.tscn")
@onready var save_buttons = $MenuBoxContainer/MenuButtonContainer.get_children()
@onready var l_arrow = $LeftArrow
@onready var r_arrow = $RightArrow

var _index: int = 0:
	set(value):
		_index = value
		_update_selection()
const _SAVE_DIR = "user://Saves"


func _ready() -> void:
	#var ini = Vector2(153.0, 281.0)
	#l_arrow.global_position = ini + Vector2(-45, 33/2)
	#r_arrow.global_position = ini + Vector2(45 + 115, 33/2)
	call_deferred("_update_selection")

func _update_selection():
	var btn = save_buttons[_index]
	var btn_center = btn.global_position + btn.size / 2.0
	var btn_half_width = btn.size.x / 2.0
	
	const padding = 20
	l_arrow.global_position = btn_center
	l_arrow.global_position.x -= btn_half_width + l_arrow.texture.get_width() / 2.0 - padding
	r_arrow.global_position = btn_center
	r_arrow.global_position.x += btn_half_width + r_arrow.texture.get_width() / 2.0 - padding

func _input(event):
	if event.is_action_pressed("right"):
		_index = (_index + 1) % save_buttons.size()
	elif event.is_action_pressed("left"):
		_index = (_index - 1) % save_buttons.size()
	elif event.is_action_pressed("ui_accept"): # Enter key
		press()
		GameManager.is_paused = false
	elif event.is_action_pressed("pause"):
		var pause_menu_inst = pause_menu.instantiate()
		get_tree().paused = true
		self.get_parent().queue_free()
		var top_layer = CanvasLayer.new()
		top_layer.layer = 2
		get_tree().root.add_child(top_layer)
		get_tree().paused = true
		pause_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
		top_layer.add_child(pause_menu_inst)


func press():
	for node in get_tree().root.get_children():
		if node is BaseLevel:
			GameManager.save_data["position"] = node.get_node("Player").global_position
			GameManager.save_data["level"] = node.level_id
	var json = JSON.stringify(GameManager.save_data)
	
	var save_path = "{0}/{1}.json".format([_SAVE_DIR, save_buttons[_index].name])
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json)
	file.close()
	
	get_tree().paused = false
	self.get_parent().queue_free()
