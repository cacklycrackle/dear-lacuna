extends Node2D

const SPEED = 280.0
var moveable = true

func _process(delta):
	var velocity = Vector2.ZERO
	
	# Check arrow key inputs
	if moveable:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
	
	position += velocity * SPEED * delta
