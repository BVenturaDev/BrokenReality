extends Control

var level = preload("res://scenes/levels/MainLevel.tscn")

onready var options = $MarginContainer

func _on_PlayButton_pressed():
	get_tree().change_scene_to(level)

func _on_OptionsButton_pressed():
	options.visible = true

func _on_QuitButton_pressed():
	get_tree().quit()
