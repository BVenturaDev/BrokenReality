extends Spatial

var sanity_boost = 10

onready var player = get_tree().current_scene.find_node("Player")
onready var hitbox = $HitBox

func _process(delta: float) -> void:
		if player in hitbox.get_overlapping_bodies():
			player.sanity += sanity_boost
			queue_free()
