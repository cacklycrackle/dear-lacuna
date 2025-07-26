extends Node2D
class_name BaseLevel


var level_id: int
var save_name: String
var stands_solved: Array[bool]
@onready var pause_menu = preload("res://common/ui/pause_menu/pause_menu.tscn")
var pause_menu_inst = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	GameManager.is_paused = false
	save_name = name.to_snake_case()
	
	var player_inst = GameManager.spawn_player(self)
	if GameManager.save_data["first_start"]:
		GameManager.save_data["first_start"] = false
		player_inst.global_position = Vector2(30, 500)
	add_child(player_inst)
	
	VisionManager.init_vision_for_level()
func _input(event):
	if event.is_action_pressed("pause") and not GameManager.in_puzzle:
		GameManager.is_paused = !GameManager.is_paused
		if GameManager.is_paused:
			var top_layer = CanvasLayer.new()
			top_layer.layer = 1
			get_tree().root.add_child(top_layer)
			pause_menu_inst = pause_menu.instantiate()
			get_tree().paused = true
			pause_menu_inst.process_mode = Node.PROCESS_MODE_ALWAYS
			top_layer.add_child(pause_menu_inst)
			pause_menu_inst.level = self
		
