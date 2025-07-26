extends Control


@onready var title = $TitleLabel
@onready var menu_buttons = $MenuButtonContainer.get_children()
@onready var load_button = $MenuButtonContainer/Load
@onready var l_arrow = $LeftArrow
@onready var r_arrow = $RightArrow

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
	var btn: Button = menu_buttons[current_selection]
	var btn_center = btn.global_position + btn.size / 2.0
	var btn_half_width = btn.size.x / 2.0
	
	const padding = 5
	l_arrow.global_position = btn_center
	l_arrow.global_position.x -= btn_half_width + l_arrow.texture.get_width() / 2.0 - padding
	r_arrow.global_position = btn_center
	r_arrow.global_position.x += btn_half_width + r_arrow.texture.get_width() / 2.0 - padding

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
	#get_tree().change_scene_to_file("res://levels/level_1/level_1.tscn")
	GameManager.reset_levels()
	GameManager.load_level()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_keybinds_pressed() -> void:
	set_process_input(false)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://common/ui/settings_menu/input_settings.tscn")

func _on_load_pressed() -> void:
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
	load_button.disabled = not files
