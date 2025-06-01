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

func _set_default_keybind_settings() -> void:
	for action_name in InputMap.get_actions():
		# Skip built-in UI actions
		if action_name.begins_with("ui_"): continue
		
		# Add single default keybind event per custom action
		var default_events = InputMap.action_get_events(action_name)
		if default_events.is_empty(): continue
		_config.set_value("keybinds", action_name, default_events[0])


func save_keybinds(action: StringName, event: InputEvent) -> void:
	_config.set_value("keybinds", action, event)
	_config.save(_SETTINGS_FILE_PATH)

func load_keybinds() -> Dictionary[String, InputEvent]:
	var keybinds: Dictionary[String, InputEvent] = {}
	for key in  _config.get_section_keys("keybinds"):
		var input_event = _config.get_value("keybinds", key)
		if input_event is InputEvent:
			keybinds[key] = input_event
		else:
			printerr("Keybind settings saved incorrectly")
	return keybinds
