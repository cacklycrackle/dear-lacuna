extends Node


var pause_menu = preload("res://common/ui/pause_menu/pause_menu.tscn")
var player = preload("res://entities/player/player.tscn")
var spawn_at_portal = "Portal1"
var in_puzzle = false
var load_from_save = false
# Note: standardise keys to snake_case
var save_data = {
	"level": null,
	"position": null,
	"first_start" : true,
	"level_2" : {"stand_1": false} 
}

func _ready() -> void:
	var canvas_layer_instance: CanvasLayer = CanvasLayer.new()
	var pause_menu_instance: Control = pause_menu.instantiate()
	canvas_layer_instance.layer = 100
	canvas_layer_instance.add_child(pause_menu_instance)
	get_tree().root.add_child.call_deferred(canvas_layer_instance)
