extends Node


const _SETTINGS_FILE_PATH = "user://settings.cfg"
var _config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	if not FileAccess.file_exists(_SETTINGS_FILE_PATH):
		_set_default_keybind_settings()
		var err = _config.save(_SETTINGS_FILE_PATH)
		if err != OK:
			printerr(error_string(err))
	else:
		var err = _config.load(_SETTINGS_FILE_PATH)
		if err != OK:
			printerr(error_string(err))

#func _event_to_str(event: InputEvent) -> String:
	#if event is InputEventKey:
		#return OS.get_keycode_string(event.physical_keycode)
	#elif event is InputEventMouseButton:
		#return "mouse_" + str(event.button_index)
	#else:
		#return ""

func _set_default_keybind_settings() -> void:
	for action_name in InputMap.get_actions():
		# Skip built-in UI actions
		if action_name.begins_with("ui_"): continue
		
		# Add single default keybind event per custom action
		var default_events: Array[InputEvent] = InputMap.action_get_events(action_name)
		if default_events.is_empty(): continue
		#var event_str = _event_to_str(default_events[0])
		#if event_str:
		_config.set_value("keybinds", action_name, default_events[0])

func save_keybinds(action: StringName, event: InputEvent) -> void:
	#var event_str: String = _event_to_str(event)
	#if event_str:
	_config.set_value("keybinds", action, event)
	_config.save(_SETTINGS_FILE_PATH)

func load_keybinds() -> Dictionary:
	var keybinds = {}
	for key in  _config.get_section_keys("keybinds"):
		#var input_event: InputEvent
		#var event_str = _config.get_value("keybinds", key)
		#if event_str.contains("mouse_"):
			#input_event = InputEventMouseButton.new()
			#input_event.button_index = int(event_str.split("_")[1])
		#else:
			#input_event = InputEventKey.new()
			#input_event.keycode = OS.find_keycode_from_string(event_str)
		var input_event = _config.get_value("keybinds", key)
		if input_event is InputEvent:
			keybinds[key] = input_event
		else:
			printerr("Keybind settings saved incorrectly")
	return keybinds
