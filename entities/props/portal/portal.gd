extends Sprite2D

## Toggle whether portal leads to previous level (default) or next level
@export var go_to_next_level: bool = false
@onready var animation = $AnimationPlayer

var interactable = false


func _ready() -> void:
	animation.play("Default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
	if body.is_in_group(GameManager.PLAYER_GROUP) and body.collision_layer == 1:
			interactable = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.name == "Player":
	if body.is_in_group(GameManager.PLAYER_GROUP) and body.collision_layer == 1:
			interactable = false
	
func _input(event: InputEvent) -> void:
	if interactable and event.is_action_pressed("interact"):
		#get_tree().change_scene_to_file(target_scene)
		#GameManager.spawn_at_portal = target_portal
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		await tween.finished
		GameManager.move_level(go_to_next_level)
