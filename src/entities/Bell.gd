extends KinematicBody

var rotation_angle = 45

onready var fences := $Fences
onready var sprite = $Sprite3D


func ringed() -> void:
	if self.has_node("Fences"):
		fences.queue_free()
