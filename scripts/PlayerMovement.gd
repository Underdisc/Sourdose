extends Node3D

# Movement speed
var speed = 5.0
var z_at_last_need_new_block = 1
var block_size
var max_distance_x = 2.6  # Maximum distance the player can move to the right or left

@export var block_scene: PackedScene

signal need_new_block

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector3(0, 0, z_at_last_need_new_block)
	var block = block_scene.instantiate()
	block_size = block.get_node("PidgeonSpawn").get_node("Area").shape.size.z

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
	position += (velocity * delta)

	# Constrain the player's movement to the left and right
	if position.x > max_distance_x:
		position.x = max_distance_x
	elif position.x < -max_distance_x:
		position.x = -max_distance_x

	# Check for block spawning
	var dist_since_last_block_spawn = abs(position.z - z_at_last_need_new_block)
	if (dist_since_last_block_spawn > block_size):
		need_new_block.emit()
		z_at_last_need_new_block -= block_size
