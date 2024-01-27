extends RigidBody3D

# Speed at which the rigid body is initially pushed
@export var impulse_strength: float = 10.0

# Maximum distance to travel before gravity takes over completely
@export var max_distance: float = 10.0
# Tracking the distance traveled
var distance_traveled: float = 0.0
# Initial position to calculate distance from
var initial_position: Vector3 = Vector3.ZERO
# Flag to know if the initial impulse was applied
var impulse_applied: bool = false

func _ready():
	# Save the initial position
	initial_position = global_transform.origin

func _physics_process(delta: float) -> void:
	if not impulse_applied:
		# Determine the forward direction (negative z-axis)
		var forward_dir: Vector3 = -global_transform.basis.z.normalized()
		# Apply an initial impulse in the forward direction
		apply_central_impulse(forward_dir * impulse_strength)
		
		# Apply a small random angular impulse for rotation (adjust the range as needed)
		angular_velocity = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		impulse_applied = true
	
	# Calculate the distance traveled
	distance_traveled = global_transform.origin.distance_to(initial_position)
	
	# If the distance traveled is greater than the maximum, we stop applying any further impulses
	if distance_traveled >= max_distance:
		# Here you could add logic to only allow gravity to affect the object,
		# like setting linear_velocity.x and linear_velocity.z to 0 to stop horizontal movement
		linear_velocity.x = 0
		linear_velocity.z = 0
		# You could also consider deactivating or modifying the physics properties of the object
