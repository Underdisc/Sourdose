extends Node3D

@export var block_scene: PackedScene
@export var pidgeon_scene: PackedScene

var next_block_move_index = -1
var noise = FastNoiseLite.new()
var blocks: Array[Node3D]
var active_blocks: Array[int]
var inactive_blocks: Array[int]
var pidgeons: Array[Node3D]
var pidgeon_frequency = 3


func _ready():
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 3.0
	spawn_blocks()
	for i in 7:
		add_block_to_path()

func spawn_blocks():
	for i in 6:
		spawn_block(i, i * 2, PI / 2)
		spawn_block(i, i * 2 + 1, -PI / 2)

func spawn_block(mesh_idx, idx, spin):
	var block = block_scene.instantiate()
	var block_mesh = block.block_meshes[mesh_idx].instantiate()
	block_mesh.rotation.y = spin
	block_mesh.position.y = -0.353
	block.add_child(block_mesh)
	block.position.z = 10
	blocks.append(block)
	add_child(block)
	inactive_blocks.push_back(idx)
	instantiate_pidgeons(block)

func instantiate_pidgeons(block):
	var spawn_area = block.get_node("PidgeonSpawn").get_node("Area")
	var area_size = spawn_area.shape.size
	for x in range(0, floor(area_size.x * pidgeon_frequency)):
		for z in range(0, floor(area_size.z * pidgeon_frequency)):
			var pidgeon = pidgeon_scene.instantiate()
			pidgeon.position = Vector3(0, 0, 10);
			add_child(pidgeon)
			pidgeons.push_back(pidgeon)

func remove_block_from_path():
	inactive_blocks.push_back(active_blocks.front())
	active_blocks.pop_front()
	pass

func add_block_to_path():
	var inactive_idx = randi_range(0, inactive_blocks.size() - 1)
	var block_idx = inactive_blocks[inactive_idx]
	var block = blocks[block_idx]
	var move_point = Vector3.ZERO
	var collision_volume = block.get_node("Ground").get_node("CollisionVolume")
	move_point.z = -1 * next_block_move_index * collision_volume.shape.size.z
	next_block_move_index += 1
	block.position = move_point
	add_pidgeons_to_block(block)
	active_blocks.push_back(block_idx)
	inactive_blocks.remove_at(inactive_idx)
	

func add_pidgeons_to_block(block):
	var spawn_area = block.get_node("PidgeonSpawn").get_node("Area")
	var area_size = spawn_area.shape.size
	var dimensions = Vector2(area_size.x, area_size.z)
	var half_dims = dimensions / 2
	var scan_start = Vector2(block.position.x - half_dims.x, block.position.z + half_dims.y)
	for x in range(0, floor(area_size.x * pidgeon_frequency)):
		for z in range(0, floor(area_size.z * pidgeon_frequency)):
			var offset = Vector2(float(x) / pidgeon_frequency, -float(z) / pidgeon_frequency)

			var possible_spawn = scan_start + offset
			var sample = noise.get_noise_2dv(possible_spawn) * 0.7
			var bias = 0.2
			if sample + randf() * bias > 0:
				var y_pos = spawn_area.position.y - spawn_area.shape.size.y / 2
				var move_position = Vector3(possible_spawn.x, y_pos, possible_spawn.y)
				move_pidgeon(move_position)


func move_pidgeon(move_position):
	var pidgeon = pidgeons.front()
	var offset = Vector3(randf_range(-0.05, 0.05),0, randf_range(-0.05, 0.05))
	pidgeon.position = move_position + offset
	pidgeon.rotation.y = randf_range(-PI, PI)
	pidgeon.moved_onto_block()
	pidgeons.pop_front()
	pidgeons.push_back(pidgeon)

func _on_player_need_new_block():
	add_block_to_path()
	remove_block_from_path()
