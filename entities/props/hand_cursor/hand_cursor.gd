extends Node2D
class_name HandCursor

var speed := 400.0
var moveable := true

func _process(delta):
	var velocity = Vector2.ZERO
	
	# Check input actions
	if moveable:
		if Input.is_action_pressed("right"):
			velocity.x += 0.5
		if Input.is_action_pressed("left"):
			velocity.x -= 0.5
		if Input.is_action_pressed("down"):
			velocity.y += 0.5
		if Input.is_action_pressed("up"):
			velocity.y -= 0.5
	
	position += velocity * speed * delta
