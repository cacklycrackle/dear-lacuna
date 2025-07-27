extends Control


@onready var input_button_scene = preload("res://common/ui/settings_menu/input_button.tscn")

# Remapping vars
var is_remapping = false
var action_to_remap = null
var remapping_button = null

# Input actions that user can view and rebind
var input_actions: Dictionary[String, String] = {
	"up"       : "move up",
	"down"     : "move down",
	"left"     : "move left",
	"right"    : "move right",
	"interact" : "interact",
	"pause"    : "pause",
}
var last_created_btn: Button = null


func _ready() -> void:
	_create_action_list()
	
	if %ActionList.get_child_count() > 0:
		var first_btn: Button = %ActionList.get_child(0)
		if first_btn:
			first_btn.call_deferred("grab_focus")

# Create default list of actions
func _create_action_list() -> void:
	for item in %ActionList.get_children():
		item.free()
	last_created_btn = %ResetButton
	
	for action in input_actions:
		var button: Button = input_button_scene.instantiate()
		
		# Set action label
		var action_label: Label = button.find_child("LabelAction")
		if action_label:
			action_label.text = input_actions[action].to_upper()
		
		# Set input label
		var input_label: Label = button.find_child("LabelInput")
		if input_label:
			var events: Array[InputEvent] = InputMap.action_get_events(action)
			if events.size() > 0:
				input_label.text = events[0].as_text().trim_suffix(" (Physical)")
			else:
				input_label.text = ""
		
		%ActionList.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
		# Configure up and down focus for button
		button.focus_mode = Control.FOCUS_ALL
		if last_created_btn and is_instance_valid(last_created_btn):
			button.focus_neighbor_top = last_created_btn.get_path()
			last_created_btn.focus_neighbor_bottom = button.get_path()
		last_created_btn = button
	
	# Link last action button to reset button
	if last_created_btn and is_instance_valid(last_created_btn):
		last_created_btn.focus_neighbor_bottom = %ResetButton.get_path()
		%ResetButton.focus_neighbor_top = last_created_btn.get_path()

# Toggle rebinding for pressed button
func _on_input_button_pressed(btn: Button, actn: String) -> void:
	if is_remapping: return
	is_remapping = true
	action_to_remap = actn
	remapping_button = btn
	btn.find_child("LabelInput").text = "Press key to bind ..."

func _input(event: InputEvent) -> void:
	if not is_remapping:
		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
			GameManager.load_start_from(self)
		return
	
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
	
	# Refresh display to default keybinds and reset focus
	_create_action_list()
	if %ActionList.get_child_count() > 0:
		var first_btn: Button = %ActionList.get_child(0)
		if first_btn:
			first_btn.call_deferred("grab_focus")
