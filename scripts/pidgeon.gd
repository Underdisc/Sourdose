extends Node3D

signal pidgeon_hit
var velocity = Vector3.ZERO

@onready var anim_player : AnimationPlayer = $"pidgeon/AnimationPlayer"

func _on_area_3d_body_entered(body):
	pidgeon_hit.emit()
	velocity = Vector3(randf_range(-1, 1), randf_range(0, 1), randf_range(-1,1))
	velocity = velocity.normalized()
	var quat = Quaternion(Vector3(1, 0, 0), velocity)
	velocity *= randf_range(2, 5)
	rotation = quat.get_euler()
	var speed = randf_range(1, 3)
	anim_player.play("pidgeon-a-fluttering", -1, speed, false)
	anim_player.advance(0)

func _process(delta):
	position += velocity * delta

func moved_onto_block():
	var speed = randf_range(1, 3)
	anim_player.play("pidgeon-idle", -1, speed, false)
	anim_player.seek(randi() % 1)
	velocity = Vector3.ZERO
	rotation.x = 0
	rotation.y = randf_range(-PI, PI)
	rotation.z = 0

