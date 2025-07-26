extends BaseLevel


func _ready() -> void:
	super._ready()
	level_id = 1
	
	#var player_inst = GameManager.spawn_player(self)
	#if GameManager.save_data["first_start"]:
		#GameManager.save_data["first_start"] = false
		#player_inst.global_position = Vector2(30, 500)
	#add_child(player_inst)
	GameManager.spawn_player(self)
	VisionManager.init_vision_for_level()
