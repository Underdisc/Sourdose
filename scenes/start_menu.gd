extends Control

@export var environment_scene: PackedScene

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(environment_scene)
