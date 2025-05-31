extends Control


@onready var input_button_scene = preload("res://Scenes/ui/input_button.tscn")
@onready var action_list = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

# Remapping vars
var is_remapping = false
var action_to_remap = null
var remapping_button = null

# Input actions that user can view and rebind
var input_actions: Dictionary[String, String] = {
	"up"        : "move up",
	"down"      : "move down",
	"left"      : "move left",
	"right"     : "move right",
	"interact"  : "interact"
}


func _ready() -> void:
	_load_keybinds_from_settings()
	_create_action_list()

func _load_keybinds_from_settings() -> void:
	var keybinds = ConfigFileHandler.load_keybinds()
	
	for action in keybinds:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinds[action])

# Create default list of actions
func _create_action_list() -> void:
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button: Button = input_button_scene.instantiate()
		
		# Set action label
		var action_label: Label = button.find_child("LabelAction")
		action_label.text = input_actions[action].to_upper()
		
		# Set input label
		var input_label: Label = button.find_child("LabelInput")
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

# Toggle rebinding for pressed button
func _on_input_button_pressed(btn: Button, actn: String) -> void:
	if is_remapping: return
	is_remapping = true
	action_to_remap = actn
	remapping_button = btn
	btn.find_child("LabelInput").text = "Press key to bind ..."

func _input(event: InputEvent) -> void:
	if not is_remapping: return
	
	# Allow rebinding to only keypresses and mouse clicks
	if event is InputEventKey or \
	 (event is InputEventMouseButton and event.is_pressed()):
		# Remove existing keybinds for event
		InputMap.action_erase_events(action_to_remap)
		
		# Add new keybind for event
		InputMap.action_add_event(action_to_remap, event)
		
		# Save changes to user config
		ConfigFileHandler.save_keybinds(action_to_remap, event)
		
		# Update keybind display
		remapping_button.find_child("LabelInput").text = \
			event.as_text().trim_suffix(" (Physical)")
		
		# Reset remapping vars
		is_remapping = false
		action_to_remap = null
		remapping_button = null
		
		# Prevent event from propagating further up tree
		accept_event()

func _on_reset_button_pressed() -> void:
	# Load default keybinds
	InputMap.load_from_project_settings()
	
	# Update user config to contain default keybinds
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinds(action, events[0])
	
	# Refresh display to default keybinds
	_create_action_list()


func _on_back_button_pressed() -> void:
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Scenes/Start_Menu.tscn")
