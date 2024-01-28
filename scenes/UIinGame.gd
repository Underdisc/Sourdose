extends Control

@export var gameText: RichTextLabel
var current_bread_count: int = 100
@export var max_bread_count: int = 100

signal bread_thrown

func _ready():
	current_bread_count = max_bread_count


func _on_bread_thrown():
	current_bread_count -= 0.1
	bread_thrown.emit()
	update_ui()
	

func update_ui():
	if current_bread_count <= 0:
		current_bread_count = 0
	gameText.text = str(current_bread_count) + "/" + str(max_bread_count)

