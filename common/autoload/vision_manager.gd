extends Node


var bg_group_name: String = "fade_on_vision"
var player: Node2D = null


func init_vision_for_level() -> void:
	var players = get_tree().get_nodes_in_group(GameManager.player_group)
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
	var bg_nodes = get_tree().get_nodes_in_group(bg_group_name)
	for node in bg_nodes:
		if node is CanvasItem:
			var material = node.material
			if material is ShaderMaterial:
				material.set_shader_parameter("player_pos", pos)
