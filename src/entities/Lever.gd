extends KinematicBody

var rotation_angle = 45

onready var fences := $Fences
onready var sprite = $AnimatedSprite3D

func hitted() -> void:
	if self.has_node("Fences"):
		sprite.play("hitted")
		fences.queue_free()
