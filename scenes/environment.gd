extends Node3D

@export var block_scene: PackedScene

var next_block_spawn_index = 0

func _ready():
	$BlockTimer.start(2)

func _on_block_timer_timeout():
	spawn_block()

# This should be called once the player reaches a point where a new block needs
# to be spawned.
func spawn_block():
	var block = block_scene.instantiate()
	var collision_volume = block.get_node("Ground").get_node("CollisionVolume")
	var spawn_point = Vector3.ZERO
	spawn_point.z = -1 * next_block_spawn_index * collision_volume.shape.size.z
	next_block_spawn_index += 1
	print(spawn_point.z)
	block.position = spawn_point
	add_child(block)
