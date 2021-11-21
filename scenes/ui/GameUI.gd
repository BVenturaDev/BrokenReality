extends Control

onready var hp = $ProgressBar
onready var levers = $HBoxContainer/Label
onready var pause = $Pause
onready var options = $MarginContainer


func _process(delta):
	levers.text = str(UiInfo.levers)
	hp.value = UiInfo.sanity

func _switch_pause():
	if not get_tree().paused:
		pause.visible = true
		get_tree().paused = true
	else:
		pause.visible = false
		get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_switch_pause()


func _on_Resume_pressed():
	_switch_pause()

func _on_Options_pressed():
	options.visible = true

func _on_Quit_pressed():
	get_tree().quit()
