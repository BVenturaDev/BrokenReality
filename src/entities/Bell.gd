extends KinematicBody

var rotation_angle = 45

onready var door := $OpenableDoor
onready var sprite = $Sprite3D


func ringed() -> void:
	if self.has_node("OpenableDoor"):
		door.queue_free()
