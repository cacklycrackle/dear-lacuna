extends Node


const BASE_RADIUS: float = 25.0
const BG_GROUP_NAME: String = "fade_on_vision"
var player: Node2D = null


func init_vision_for_level() -> void:
	var players = get_tree().get_nodes_in_group(GameManager.PLAYER_GROUP)
	if players.size() > 0:
		player = players[0]
		set_process(true)
	else:
		print("ERROR: Player not found in group")
		set_process(false)

func _process(_delta: float) -> void:
	if not player: return
	if not is_instance_valid(player):
		player = null
		set_process(false)
		return
	
	var pos = player.global_position
	var bg_nodes = get_tree().get_nodes_in_group(BG_GROUP_NAME)
	for node in bg_nodes:
		if node is CanvasItem:
			var material = node.material
			if material is ShaderMaterial:
				var radius = BASE_RADIUS + 8.5 * GameManager.curr_level
				material.set_shader_parameter("radius", radius)
				material.set_shader_parameter("player_pos", pos)
