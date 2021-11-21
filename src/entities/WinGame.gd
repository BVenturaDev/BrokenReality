extends Area

onready var player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	if player in get_overlapping_bodies():
		player.add_child(player.dialog_after_win)
