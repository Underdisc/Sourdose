extends Node3D

# Preload the model scene
var model_scene: PackedScene = preload("res://scenes/Bread.tscn")

# Speed at which the model is shot
var shoot_speed: float = 10.0

signal thrown

func _ready():
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot_bread"):
		shoot_model()

func shoot_model() -> void:
	# Instance the model scene
	var model_instance: Node = model_scene.instantiate()
	
	# Assuming the BreadLauncher is a direct child of the Player
	var player_node: Node3D = get_parent() as Node3D
	
	# Add the model instance to the scene at the root level
	get_tree().root.add_child(model_instance)
	
	# Set it to start at the player's location
	model_instance.global_transform.origin = player_node.global_transform.origin

	# Emit the "thrown" signal when the bread is generated
	thrown.emit()
	
	# Apply an initial forward force or velocity
	if model_instance is RigidBody3D:
		var velocity: Vector3 = -player_node.global_transform.basis.z.normalized() * shoot_speed
		model_instance.apply_impulse(Vector3.ZERO, velocity)
