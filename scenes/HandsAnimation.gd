extends Control

# Time interval variable visible in the inspector
@export var interval: float = 0.1

# Current index of the child being rotated
var current_child_index = 0

# Animation state
var is_animating = false

# Timer
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the timer
	timer = Timer.new()
	timer.wait_time = interval
	timer.one_shot = false  # Repeating timer
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()  # Start the timer

	# Hide all children initially
	for child in get_children():
		if child is TextureRect:
			child.visible = false

# Function to handle the timer timeout
func _on_Timer_timeout():
	var children = get_child_count()

	# Only proceed if we are animating
	if is_animating:
		# Hide previous TextureRect child
		if current_child_index > 0:
			var previous_child = get_child((current_child_index - 1) % children)
			if previous_child is TextureRect:
				previous_child.visible = false

		# Show next TextureRect child
		if current_child_index < children:
			var current_child = get_child(current_child_index)
			if current_child is TextureRect:
				current_child.visible = true
			current_child_index += 1

		# Check if it's the last child
		if current_child_index >= children:
			current_child_index = 0
			is_animating = false

# Function to start the animation when the signal is received
func _on_start_animation():
	is_animating = true
	current_child_index = 0
