extends KinematicBody

onready var door := $OpenableDoor

func hitted() -> void:
	if self.has_node("OpenableDoor"):
		door.queue_free()
