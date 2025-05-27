extends Control

@onready var menu_container = $VBoxContainer
@onready var L_ani = $"Left Arrow/Left Animation"
@onready var L_arrow = $"Left Arrow"
@onready var R_ani = $"Right Arrow/Right Animation"
@onready var R_arrow = $"Right Arrow"
@onready var Title = $Title

var menu_buttons = []
var current_selection = 0

var debug_timer_length = 2
var debug_timer = 0

var title_velocity = .2
var title_max_displacement = 25
var title_initial_y = 0
var direction = 1

func _ready():
	title_initial_y = Title.global_position.y

	for child in menu_container.get_children():
		menu_buttons.append(child)
	
	# Initialize selection	
	R_ani.play("Default")
	L_ani.play("Default")
	L_arrow.global_position.y = menu_buttons[current_selection].global_position.y + 16.5
	R_arrow.global_position.y = menu_buttons[current_selection].global_position.y + 16.5
	L_arrow.global_position.x = menu_buttons[current_selection].global_position.x + 10
	R_arrow.global_position.x = menu_buttons[current_selection].global_position.x + 200 -  10
	

func _physics_process(delta):
	
	Title.global_position.y = Title.global_position.y + title_velocity * direction
	if Title.global_position.y - title_initial_y <= 0 or Title.global_position.y - title_initial_y >= title_max_displacement:
		direction *= -1 
	debug_timer += delta
	if debug_timer > debug_timer_length:
		#checks
		#print(menu_buttons[current_selection].global_position.y)
		debug_timer = 0

func update_selection():
	L_arrow.global_position.y = menu_buttons[current_selection].global_position.y + 16.5
	R_arrow.global_position.y = menu_buttons[current_selection].global_position.y + 16.5
	
			
func _input(event):
	if event.is_action_pressed("ui_down"):
		current_selection = (current_selection + 1) % menu_buttons.size()
		update_selection()
	elif event.is_action_pressed("ui_up"):
		current_selection = (current_selection - 1) % menu_buttons.size()
		update_selection()
	elif event.is_action_pressed("ui_accept"): # Enter key
		press(current_selection)


func press(index):
	menu_buttons[index].pressed.emit()

func _on_start_pressed() -> void:
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")
	
