extends KinematicBody

var rotation_angle = 45

onready var fences := $Fences
onready var sprite = $Sprite3D
onready var sfx = $SFX
onready var bell : AudioStreamSample = preload("res://assets/SFX/Bell_Ring.wav")


func ringed() -> void:
	sfx.stream = bell
	sfx.play()
	if self.has_node("Fences"):
		fences.queue_free()
