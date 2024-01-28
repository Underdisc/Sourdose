extends Control

# Export the delay variable to make it adjustable in the inspector
@export var delay_seconds: float = 60.0

# Timer
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize and configure the timer
	timer = Timer.new()
	timer.wait_time = delay_seconds
	timer.one_shot = true
	timer.connect("timeout", enable_random_texture_rect)
	add_child(timer)
	timer.start()

	# Initially disable all TextureRect children
	for child in get_children():
		if child is TextureRect:
			child.visible = false

# Function to randomly enable one of the TextureRect children
func enable_random_texture_rect():
	var texture_rects = []

	# Collect all TextureRect children
	for child in get_children():
		if child is TextureRect:
			texture_rects.append(child)
	
	# Check if there are any TextureRect children
	if texture_rects.size() == 0:
		print("No TextureRect children found.")
		return

	# Randomly select one TextureRect
	var random_index = randi() % texture_rects.size()
	var selected_texture_rect = texture_rects[random_index]

	# Make all TextureRects invisible
	for texture_rect in texture_rects:
		texture_rect.visible = false

	# Make the selected TextureRect visible
	selected_texture_rect.visible = true
