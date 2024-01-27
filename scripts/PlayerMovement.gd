extends Node3D

# Movement speed
var speed = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector3.ZERO  # The player's movement velocity

	# Get input
	if Input.is_action_pressed("move_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	# Normalize the velocity to ensure consistent movement speed in all directions
	velocity = velocity.normalized() * speed

	# Apply the movement
	translate(velocity * delta)
