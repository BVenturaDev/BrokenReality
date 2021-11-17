extends StaticBody

var number_of_levers : int
var final_countdown := 0 setget set_final_countdown

func _ready() -> void:
	for lever in get_tree().get_nodes_in_group("final_levers"):
		number_of_levers += 1

func set_final_countdown(value) -> void:
	final_countdown = value
	if final_countdown == number_of_levers:
		queue_free()
