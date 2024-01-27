extends Node3D

@export var block_scene: PackedScene
@export var pidgeon_scene: PackedScene

var next_block_spawn_index = 0
var noise = FastNoiseLite.new()

func _ready():
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 3.0
	$BlockTimer.start(1)
	spawn_block()

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
	block.position = spawn_point
	add_child(block)
	spawn_pidgeons(block)

func spawn_pidgeons(block):
	var spawn_area = block.get_node("PidgeonSpawn").get_node("Area")
	var area_size = spawn_area.shape.size
	var dimensions = Vector2(area_size.x, area_size.z)
	var half_dims = dimensions / 2
	var scan_start = Vector2(block.position.x - half_dims.x, block.position.z + half_dims.y)
	var frequency = 5
	for x in range(0, floor(area_size.x * frequency)):
		for z in range(0, floor(area_size.z * frequency)):
			var offset = Vector2(float(x) / frequency, -float(z) / frequency)
			var possible_spawn = scan_start + offset
			var sample = noise.get_noise_2dv(possible_spawn) * 0.7
			var bias = 0.2
			if sample + randf() * bias > 0:
				spawn_pidgeon(possible_spawn)

func spawn_pidgeon(spawn_position):
	var pidgeon = pidgeon_scene.instantiate()
	var offset = Vector3(randf_range(-0.05, 0.05),0, randf_range(-0.05, 0.05))
	pidgeon.position = Vector3(spawn_position.x, 0, spawn_position.y) + offset
	pidgeon.rotation.y = randf_range(-PI, PI)
	add_child(pidgeon)
