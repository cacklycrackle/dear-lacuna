extends RigidBody2D


var is_thrown: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	is_thrown = false

func _physics_process(delta: float) -> void:
	if is_thrown and linear_velocity.length() == 0.0 and angular_velocity == 0.0:
		await get_tree().create_timer(2.0).timeout
		is_thrown = false

func throw_rock(impulse: Vector2) -> void:
	freeze = false
	apply_central_impulse(impulse)
	is_thrown = true
