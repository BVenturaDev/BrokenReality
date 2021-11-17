extends KinematicBody

var hitted := false 

onready var final_door = get_parent().find_node("FinalDoor")

func _init() -> void:
	add_to_group("final_levers") 

func hitted() -> void:
	if !hitted:
		final_door.final_countdown += 1
	hitted == true

