extends Control

func _ready():
	#$Control.visible = false
	$"BannerCooldown Timer".start()
	
	var children = get_child_count()
	for i in range(children):
		var child = get_child(i)
		if child is TextureRect:
			child.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	await $"BannerCooldown Timer".timeout
	
	# hide all current banners
	var children = get_child_count()
	for i in range(children):
		var child = get_child(i)
		if child is TextureRect:
			child.visible = false
	
	# choose whether a banner shall be displayed

	# find random banner an enable it
	randomize()
	var banners = get_children()
	var banner = banners[randi() % banners.size()]
	if banner is TextureRect:
			banner.set_visible(true)
		
	$"BannerCooldown Timer".start()
