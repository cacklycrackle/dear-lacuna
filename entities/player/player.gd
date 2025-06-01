extends CharacterBody2D


@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var collision = $CollisionPolygon2D

const SPEED = 280.0
const ACCELERATION = 2200.0
const FRICTION = 1800.0

var gravity = 1500.0
var can_move = true

# jumping vars
const JUMP_VELOCITY = -250.0
var has_jumped = true
var in_jump = false
var start_jump_y_coord = 0
var max_jump_time = 0.3
var can_double_jump = false
var jump_timer = 0.0
var jumpcount = 2


func _ready():
	animation.play("Idle")

func _physics_process(delta):
	var viewport_rect = get_viewport_rect()
	position = position.clamp(Vector2.ZERO, viewport_rect.size)
	global_position.x = clamp(global_position.x, 17, viewport_rect.size.x - 17)
	if is_on_floor():
		has_jumped = false
		in_jump = false
		can_double_jump = true
		jump_timer = 0.0
		jumpcount = 2
	#if not is_on_floor():
		#velocity.y += gravity * delta
	can_move = not GameManager.in_puzzle
	if can_move:
		jump(delta)
		handle_horizontal(delta)
		move_and_slide()
	handle_gravity(delta)

	
func handle_gravity(delta):
	if in_jump:
		pass # placeholder
	elif not is_on_floor():
		var current_gravity = gravity
		velocity.y += current_gravity * delta

func handle_horizontal(delta):
	var direction = Input.get_axis("left", "right")
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	else:
		velocity.x = SPEED * direction
		sprite.flip_h = (direction < 0)

func jump(delta):
	if Input.is_action_just_pressed("up"):
		if (not has_jumped and is_on_floor()) or (has_jumped and can_double_jump and jumpcount > 0):
			start_jump_y_coord = global_position.y
			velocity.y = JUMP_VELOCITY
			in_jump = true	
			has_jumped = true
			jumpcount -= 1
			jump_timer = 0.0
	elif Input.is_action_pressed("up") and in_jump:
			jump_timer += delta
			if jump_timer < max_jump_time:
				velocity.y = JUMP_VELOCITY
			else:
				in_jump = false 
	elif Input.is_action_just_released("up"):
		in_jump = false
