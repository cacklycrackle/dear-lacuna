extends Control

@onready var menu_container = $VBoxContainer
@onready var l_ani = $LeftArrow/LeftAnimation
@onready var l_arrow = $LeftArrow
@onready var r_ani = $RightArrow/RightAnimation
@onready var r_arrow = $RightArrow
@onready var title = $Label
@onready var load_button = $"VBoxContainer/Load"

var save_menu = preload("res://common/ui/save_menu/save_menu.tscn")
var load_menu = load("res://common/ui/load_menu/load_menu.tscn")
var menu_buttons: Array[Node]
var current_selection = 0
var level = null

func _ready():
	can_load()
	menu_buttons = menu_container.get_children()
	var button: Button = $VBoxContainer/Save
	l_arrow.global_position = button.global_position + Vector2(-30, button.size.y / 2)
	r_arrow.global_position.y = l_arrow.global_position.y
	r_arrow.global_position.x = button.global_position.x + 184 + 30
	r_ani.play("Default")
	l_ani.play("Default")
	update_selection()

func can_load():
	var files = DirAccess.get_files_at("user://Saves")
	if not files:
		load_button.disabled = true
	else:
		load_button.disabled = false

func update_selection():
	var button: Button = menu_buttons[current_selection]
	l_arrow.global_position = button.global_position + Vector2(-30, button.size.y / 2)
	r_arrow.global_position.y = l_arrow.global_position.y
	r_arrow.global_position.x = button.global_position.x + 184 + 30

func _input(event):
	if event.is_action_pressed("down"):
		current_selection = (current_selection + 1) % menu_buttons.size()
		update_selection()
	elif event.is_action_pressed("up"):
		current_selection = (current_selection - 1) % menu_buttons.size()
		update_selection()
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
	top_layer.layer = 1
	get_tree().root.add_child(top_layer)
	self.get_parent().queue_free()
	top_layer.add_child(save_menu_inst)
	

func _on_load_pressed() -> void:
	var load_menu_inst = load_menu.instantiate()
	load_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
	var top_layer = CanvasLayer.new()
	top_layer.layer = 1
	get_tree().root.add_child(top_layer)
	self.get_parent().queue_free()
	top_layer.add_child(load_menu_inst)
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://common/ui/start_menu/start_menu.tscn")
	self.get_parent().queue_free()
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	print("E")
	pass # Replace with function body.
