extends Node2D
class_name HandCursor

const SPEED = 280.0
var moveable = true

func _process(delta):
	var velocity = Vector2.ZERO
	
	# Check input actions
	if moveable:
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
	
	position += velocity * SPEED * delta
