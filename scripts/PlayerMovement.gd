extends Node3D

# Movement speed
var speed = 5.0
var z_at_last_need_new_block = 1;
var block_size

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
	
	var dist_since_last_block_spawn = abs(position.z - z_at_last_need_new_block)
	if (dist_since_last_block_spawn > block_size):
		need_new_block.emit()
		z_at_last_need_new_block -= block_size
		
