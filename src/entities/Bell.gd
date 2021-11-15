extends KinematicBody

onready var door := $OpenableDoor

func ringed() -> void:
	door.queue_free()
