extends Node3D

signal pidgeon_hit
var velocity = Vector3.ZERO

@onready var anim_player : AnimationPlayer = $"pidgeon/AnimationPlayer"

func _ready():
	var ui_node = get_parent().get_node("Player").get_node("UIinGame")
	pidgeon_hit.connect(ui_node._on_pidgeon_hit)

func _on_area_3d_body_entered(body):
	pidgeon_hit.emit()
	var sound_select = randi_range(0, 1)
	if sound_select == 0:
		$Sounds.get_node("1").play()
	else:
		$Sounds.get_node("2").play()
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
	var select = randi_range(0, 1)
	if select == 0:
		anim_player.play("pidgeon-idle", -1, speed, false)
	else:
		anim_player.play("pidgeon-a-eating", -1, speed, false)
	anim_player.seek(randi() % 1)
	velocity = Vector3.ZERO
	rotation.x = 0
	rotation.y = randf_range(-PI, PI)
	rotation.z = 0

