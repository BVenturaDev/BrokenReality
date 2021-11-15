extends Spatial

var speed := 80
var duration := 1
var timer : float
var direction : Vector3

onready var hitbox = $HitBox

func _process(delta: float) -> void:
	global_translate(direction * speed * delta)
	timer += delta
	if timer > duration:
		queue_free()
	var objectives = hitbox.get_overlapping_bodies()
	for objective in objectives:
		if objective.has_method("hitted"):
			objective.hitted()
			queue_free()
		if objective.has_method("ringed"):
			objective.ringed()
			queue_free()

