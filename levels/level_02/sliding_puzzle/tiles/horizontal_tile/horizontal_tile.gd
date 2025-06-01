extends Node2D


@onready var space_state = get_world_2d().direct_space_state
@onready var left_query = PhysicsPointQueryParameters2D.new()
@onready var right_query = PhysicsPointQueryParameters2D.new()

var moveable = false
var cursor
var axis = "y"


func _ready() -> void:	
	left_query.position = Vector2(global_position)
	left_query.position.x -= 90
	left_query.collision_mask = 4
	left_query.collide_with_areas = true
	
	right_query.position = Vector2(global_position)
	right_query.position.x += 90
	right_query.collision_mask = 4
	right_query.collide_with_areas = true

func _input(event: InputEvent) -> void:
	if moveable and Input.is_action_pressed("interact"):
		if event.is_action_pressed("left"):
			cursor.moveable = false
			if space_state.intersect_point(left_query).size() == 0:
				global_position.x -= 60
				left_query.position.x -= 60
				right_query.position.x -= 60
				cursor.global_position.x -= 60
		if event.is_action_pressed("right"):
			cursor.moveable = false
			if space_state.intersect_point(right_query).size() == 0:
				global_position.x += 60
				left_query.position.x += 60
				right_query.position.x += 60
				cursor.global_position.x += 60
	
	if event.is_action_released("interact"):
		if cursor:
			cursor.moveable = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	cursor = area.get_parent()
	moveable = true

func _on_area_2d_area_exited(_area: Area2D) -> void:
	moveable = false
