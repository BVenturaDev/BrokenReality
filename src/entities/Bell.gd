extends KinematicBody

onready var door := $OpenableDoor

func ringed() -> void:
	if self.has_node("OpenableDoor"):
		door.queue_free()
