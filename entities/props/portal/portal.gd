extends Sprite2D


@onready var animation = $AnimationPlayer

var interactable = false
var target_scene
var target_portal


func _ready() -> void:
	animation.play("Default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.collision_layer == 1:
			interactable = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if body.collision_layer == 1:
			interactable = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactable:
		get_tree().change_scene_to_file(target_scene)
		GameManager.spawn_at_portal = target_portal
