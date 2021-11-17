extends KinematicBody

var hitted := false 
var rotation_angle = 45

onready var final_door = get_parent().find_node("FinalDoor")
onready var sprite = $AnimatedSprite3D

func _init() -> void:
	add_to_group("final_levers") 

func hitted() -> void:
	if !hitted:
		sprite.play("hitted")
		final_door.final_countdown += 1
		hitted == true

