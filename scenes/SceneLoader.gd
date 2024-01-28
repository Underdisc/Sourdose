extends Node3D

@export var delay_seconds: float = 60.0  # Delay before switching scenes
var scene_path = "res://scenes/Endingscreen.tscn"  # Path to the scene to switch to

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize and configure the timer
	var timer = Timer.new()
	timer.wait_time = delay_seconds
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)  # Connect the timeout signal
	add_child(timer)
	timer.start()

# Function called when the timer times out
func _on_timer_timeout():
	get_tree().change_scene_to_file(scene_path)  # Change to the new scene
