extends Node2D


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		print("Switching to root")
		get_tree().change_scene_to_file("res://scenes/main.tscn")
