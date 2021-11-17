extends KinematicBody

var rotation_angle = 45

onready var door := $OpenableDoor
onready var sprite = $AnimatedSprite3D

func hitted() -> void:
	if self.has_node("OpenableDoor"):
		sprite.play("hitted")
		door.queue_free()
