extends Control

@export var gameText: RichTextLabel
var current_bread_count: int = 100
@export var max_bread_count: int = 100
var pidgeon_hit_count: int = 0

signal bread_thrown

func _ready():
	current_bread_count = max_bread_count


func _on_bread_thrown():
	current_bread_count -= 0.1
	bread_thrown.emit()
	update_ui()
	
func _on_pidgeon_hit():
	pidgeon_hit_count += 1
	$HitCount.text = str(pidgeon_hit_count)

func update_ui():
	if current_bread_count <= 0:
		current_bread_count = 0
	gameText.text = str(current_bread_count) + "/" + str(max_bread_count)

