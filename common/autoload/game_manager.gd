extends Node


const PLAYER_GROUP = "main_player"
const NO_OF_LEVELS = 6 # Change as needed

var pause_menu = preload("res://common/ui/pause_menu/pause_menu.tscn")
var player = preload("res://entities/player/player.tscn")
var spawn_at_portal = "PortalPrev" # Change to PortalPrev to debug individual level > 1
var curr_level: int = 1
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
	"level_6": {"stand_1" : false, "stand_2": false},
}


func _ready() -> void:
	var canvas_layer_inst := CanvasLayer.new()
	var pause_menu_inst: Control = pause_menu.instantiate()
	canvas_layer_inst.layer = 100
	canvas_layer_inst.add_child(pause_menu_inst)
	get_tree().root.add_child.call_deferred(canvas_layer_inst)


func spawn_player(level: BaseLevel) -> Player:
	curr_level = level.level_id # Uncomment to run individual level for debugging
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

func move_level(go_to_next: bool) -> void:
	var target_scene := ""
	if go_to_next:
		curr_level += 1
		spawn_at_portal =  "PortalPrev"
	else:
		curr_level -= 1
		spawn_at_portal = "PortalNext"
	
	if curr_level <= 0 or curr_level > NO_OF_LEVELS:
		curr_level = 1
		target_scene = "res://common/ui/start_menu/start_menu.tscn"
	else:
		target_scene = "res://levels/level_{0}/level_{0}.tscn".format([curr_level])
	get_tree().change_scene_to_file(target_scene)
