extends Control

var environment_scene = preload("res://scenes/environment.tscn")

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(environment_scene)
