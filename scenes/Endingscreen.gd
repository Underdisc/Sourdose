extends Control

@export var env_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initially disable all TextureRect children
	for child in get_children():
		if child is TextureRect:
			child.visible = false

	# Enable one TextureRect randomly
	enable_random_texture_rect()

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


func _on_retry_pressed():
	get_tree().change_scene_to_packed(env_scene)
