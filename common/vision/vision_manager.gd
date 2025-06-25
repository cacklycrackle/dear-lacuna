extends Node


@export var bg_group_name: String = "fade_on_vision"

var player: Node2D


func _ready() -> void:
	call_deferred("_find_player")

func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("player_group")
	if players.size() > 0:
		player = players[0]
	else:
		print("ERROR: Player not found in group")
		set_process(false)

func _process(_delta: float) -> void:
	if not player: return
	var pos = player.global_position
	var bg_nodes = get_tree().get_nodes_in_group(bg_group_name)
	for node in bg_nodes:
		if node is CanvasItem:
			var material = node.material
			if material is ShaderMaterial:
				material.set_shader_parameter("player_pos", pos)
