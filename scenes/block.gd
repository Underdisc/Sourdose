extends Node3D

@export var block_meshes: Array[PackedScene]

func _ready():
	var block_mesh_idx = randi_range(0, block_meshes.size() - 1)
	var block_mesh = block_meshes[block_mesh_idx].instantiate()
	var dir = randi_range(0, 1)
	if dir == 0:
		block_mesh.rotation.y = PI / 2
	else:
		block_mesh.rotation.y = -PI / 2
	block_mesh.position.y = -0.353
	add_child(block_mesh)
