extends Control

@onready var title = $MenuBoxContainer/MarginContainer/TitleLabel
@onready var menu_buttons = $MenuBoxContainer/MenuButtonContainer.get_children()
@onready var load_button = $MenuBoxContainer/MenuButtonContainer/Load
@onready var l_arrow = $LeftArrow
@onready var r_arrow = $RightArrow

var save_menu = preload("res://common/ui/save_menu/save_menu.tscn")
var load_menu = load("res://common/ui/load_menu/load_menu.tscn")
var current_selection: int = 0:
	set(value):
		current_selection = value
		_update_selection()
var level = null

func _ready():
	can_load()
	call_deferred("_update_selection")

func can_load():
	var files = DirAccess.get_files_at("user://Saves")
	load_button.disabled = not files

func _update_selection():
	var btn: Button = menu_buttons[current_selection]
	var btn_center = btn.global_position + btn.size / 2.0
	var btn_half_width = btn.size.x / 2.0
	
	l_arrow.global_position = btn_center
	l_arrow.global_position.x -= btn_half_width + l_arrow.texture.get_width() / 2.0
	r_arrow.global_position = btn_center
	r_arrow.global_position.x += btn_half_width + r_arrow.texture.get_width() / 2.0

func _input(event):
	if event.is_action_pressed("down"):
		current_selection = (current_selection + 1) % menu_buttons.size()
	elif event.is_action_pressed("up"):
		current_selection = (current_selection - 1) % menu_buttons.size()
	elif event.is_action_pressed("pause") and GameManager.is_paused:
		self.get_parent().queue_free()
		self.get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
		GameManager.is_paused = false
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"): # Enter key
		press(current_selection)

func press(index):
	if not menu_buttons[index].disabled:
		menu_buttons[index].pressed.emit()

func _on_save_pressed() -> void:
	var save_menu_inst = save_menu.instantiate()
	save_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
	var top_layer = CanvasLayer.new()
	top_layer.layer = 2
	get_tree().root.add_child(top_layer)
	self.get_parent().queue_free()
	top_layer.add_child(save_menu_inst)

func _on_load_pressed() -> void:
	var load_menu_inst = load_menu.instantiate()
	load_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
	var top_layer = CanvasLayer.new()
	top_layer.layer = 2
	get_tree().root.add_child(top_layer)
	self.get_parent().queue_free()
	top_layer.add_child(load_menu_inst)

func _on_main_menu_pressed() -> void:
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://common/ui/start_menu/start_menu.tscn")
	self.get_parent().queue_free()

func _on_exit_pressed() -> void:
	get_tree().quit()
