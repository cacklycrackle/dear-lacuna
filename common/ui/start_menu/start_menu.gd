extends Control

@onready var menu_container = $VBoxContainer
@onready var l_ani = $LeftArrow/LeftAnimation
@onready var l_arrow = $LeftArrow
@onready var r_ani = $RightArrow/RightAnimation
@onready var r_arrow = $RightArrow
@onready var title = $Title
@onready var load_button = $"VBoxContainer/Load Game"

var menu_buttons: Array[Node]
var current_selection = 0

var debug_timer_length = 2
var debug_timer = 0

var title_velocity = .2
var title_max_displacement = 25
var title_initial_y = 0
var direction = 1


func _ready():
	title_initial_y = title.global_position.y
	make_save_dir()
	can_load()
	# Initialize selection	
	menu_buttons = menu_container.get_children()
	r_ani.play("Default")
	l_ani.play("Default")
	call_deferred("update_selection")
	

func _physics_process(delta):
	title.global_position.y += title_velocity * direction
	if title.global_position.y - title_initial_y <= 0 or \
	  title.global_position.y - title_initial_y >= title_max_displacement:
		direction *= -1
	
	debug_timer += delta
	if debug_timer > debug_timer_length:
		debug_timer = 0

func update_selection():
	var button: Button = menu_buttons[current_selection]
	l_arrow.global_position = button.global_position + Vector2(-30, button.size.y / 2)
	r_arrow.global_position.y = l_arrow.global_position.y
	r_arrow.global_position.x = button.global_position.x + button.size.x + 30

func _input(event):
	if event.is_action_pressed("down"):
		current_selection = (current_selection + 1) % menu_buttons.size()
		update_selection()
	elif event.is_action_pressed("up"):
		current_selection = (current_selection - 1) % menu_buttons.size()
		update_selection()
	elif event.is_action_pressed("interact"): # Enter key
		press(current_selection)

func press(index):
	if not menu_buttons[index].disabled:
		menu_buttons[index].pressed.emit()

func _on_start_pressed() -> void:
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file("res://levels/level_1/level_1.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_controls_pressed() -> void:
	set_process_input(false)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://common/ui/settings_menu/input_settings.tscn")


func _on_load_game_pressed() -> void:
	set_process_input(false)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://common/ui/load_menu/load_menu.tscn")

func make_save_dir():
	var dir = DirAccess.open("user://")
	if dir:
		if not dir.dir_exists("Saves"):
			var err = dir.make_dir("Saves")
			if err != OK:
				printerr(error_string(err))

func can_load():
	var files = DirAccess.get_files_at("user://Saves")
	if not files:
		load_button.disabled = true
	else:
		load_button.disabled = false
