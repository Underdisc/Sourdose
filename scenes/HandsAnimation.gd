extends Control

# Time interval variable visible in the inspector
@export var interval: float = 0.2

# Current index of the child being rotated
var current_child_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize and start the timer
	var timer = Timer.new()
	timer.wait_time = interval
	timer.one_shot = false
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()
	
	get_child(0).visible = false
	get_child(1).visible = false
	get_child(2).visible = false
	

 #Function to handle the timer timeout
func _on_Timer_timeout():
	var children = get_child_count()

	# Disable all children that are TextureRects first
	for i in range(children):
		var child = get_child(i)
		if child is TextureRect:
			child.visible = false

	# Find the next TextureRect child
	var found = false
	var attempts = 0
	while not found and attempts < children:
		var current_child = get_child(current_child_index)
		if current_child is TextureRect:
			current_child.visible = true
			found = true
		# Increment the index, wrapping around if necessary
		current_child_index = (current_child_index + 1) % children
		attempts += 1

	# If no TextureRect was found after a full loop, do nothing
	if not found:
		print("No TextureRect children found.")
