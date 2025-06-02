extends Node2D


@onready var space_state = get_world_2d().direct_space_state
@onready var top_query = PhysicsPointQueryParameters2D.new()
@onready var bottom_query = PhysicsPointQueryParameters2D.new()

var moveable = false
var cursor
var axis = "x"


func _ready() -> void:
	$Sprite2D.scale = Vector2(0.9375, 0.9375)
	top_query.position = Vector2(global_position)
	top_query.position.y -= 90
	top_query.collision_mask = 4
	top_query.collide_with_areas = true
	
	bottom_query.position = Vector2(global_position)
	bottom_query.position.y += 90
	bottom_query.collision_mask = 4
	bottom_query.collide_with_areas = true
	
func _input(event: InputEvent) -> void:
	if moveable and Input.is_action_pressed("interact"):
		if event.is_action_pressed("up"):
			cursor.moveable = false
			if space_state.intersect_point(top_query).size() == 0:
				global_position.y -= 60
				top_query.position.y -= 60
				bottom_query.position.y -= 60
				cursor.global_position.y -= 60
		if event.is_action_pressed("down"):
			cursor.moveable = false
			if space_state.intersect_point(bottom_query).size() == 0:
				global_position.y += 60
				top_query.position.y += 60
				bottom_query.position.y += 60
				cursor.global_position.y += 60
	
	if event.is_action_released("interact"):
		if cursor:
			cursor.moveable = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	cursor = area.get_parent()
	moveable = true

func _on_area_2d_area_exited(_area: Area2D) -> void:
	moveable = false
