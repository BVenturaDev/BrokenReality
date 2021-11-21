extends Area

onready var player = get_parent().get_node("Player")
onready var dialog_after_win = Dialogic.start("AfterWin") 

func _process(delta: float) -> void:
	if player in get_overlapping_bodies():
		add_child(dialog_after_win)
