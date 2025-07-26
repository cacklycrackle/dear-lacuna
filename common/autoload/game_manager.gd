extends Node


const PLAYER_GROUP = "main_player"
const NO_OF_LEVELS = 7 # Change as needed

var player = preload("res://entities/player/player.tscn")
var load_from_save = false
var is_paused = false
var curr_level_no: int = 1
var spawn_at_portal = "PortalPrev"
var in_puzzle = false
var save_data # Note: standardise keys to snake_case


func _ready() -> void:
	reset_levels()

func reset_levels() -> void:
	curr_level_no = 1
	spawn_at_portal = "PortalPrev"
	in_puzzle = false
	save_data = {
		"level": null,
		"position": null,
		"level_2": {"stand_1": false},
		"level_3": {"stand_1": false},
		"level_4": {"stand_1": false},
		"level_5": {"stand_1" : false, "stand_2": false},
		"level_6": {"stand_1" : false, "stand_2": false},
		"level_7": {"stand_1" : false, "stand_2": false},
	}

## Spawns a Player onto the specified level
func spawn_player(level: BaseLevel) -> void:
	#curr_level_no = level.level_id # Uncomment only to debug individual level
	var player_inst = player.instantiate()
	if load_from_save:
		load_from_save = false
		player_inst.global_position = save_data["position"]
	else:
		var portal = level.get_node(spawn_at_portal)
		player_inst.global_position = portal.global_position
	player_inst.add_to_group(PLAYER_GROUP)
	level.add_child(player_inst)

func move_level(go_to_next: bool) -> void:
	if go_to_next:
		curr_level_no += 1
		spawn_at_portal =  "PortalPrev"
	else:
		curr_level_no -= 1
		spawn_at_portal = "PortalNext"
	load_level()

func load_level() -> void:
	var target_scene := ""
	if curr_level_no <= 0 or curr_level_no > NO_OF_LEVELS:
		curr_level_no = 1
		target_scene = "res://common/ui/start_menu/start_menu.tscn"
	else:
		target_scene = "res://levels/level_{0}/level_{0}.tscn".format([curr_level_no])
	get_tree().change_scene_to_file(target_scene)
