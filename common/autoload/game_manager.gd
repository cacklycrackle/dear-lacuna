extends Node


const PLAYER_GROUP = "main_player"
var pause_menu = preload("res://common/ui/pause_menu/pause_menu.tscn")
var player = preload("res://entities/player/player.tscn")
var spawn_at_portal = "Portal1"
var curr_level: int = 0
var in_puzzle = false
var load_from_save = false
# Note: standardise keys to snake_case
var save_data = {
	"level": null,
	"position": null,
	"first_start" : true,
	"level_2": {"stand_1": false},
	"level_3": {"stand_1": false},
	"level_4": {"stand_1": false},
	"level_5": {"stand_1" : false, "stand_2": false},
}


func _ready() -> void:
	var canvas_layer_instance: CanvasLayer = CanvasLayer.new()
	var pause_menu_instance: Control = pause_menu.instantiate()
	canvas_layer_instance.layer = 100
	canvas_layer_instance.add_child(pause_menu_instance)
	get_tree().root.add_child.call_deferred(canvas_layer_instance)

func spawn_player(level: BaseLevel) -> Player:
	curr_level = level.level_id
	var player_inst = player.instantiate()
	if load_from_save:
		load_from_save = false
		var coords_str = save_data["position"]
		var coords = coords_str.substr(1, coords_str.length() - 2).split(",")
		player_inst.global_position = Vector2(coords[0].to_float(), coords[1].to_float())
	else:
		var portal = level.get_node(spawn_at_portal)
		player_inst.global_position = portal.global_position
	player_inst.add_to_group(PLAYER_GROUP)
	return player_inst
