extends KinematicBody

var direction : Vector3
var speed = 600

onready var left := $Left
onready var right := $Right
onready var up := $Up
onready var down := $Down
onready var player = get_parent().get_node("Player")


func _process(delta: float) -> void:
	if player in left.get_overlapping_bodies():
		direction = Vector3(1,0,0)
	elif player in right.get_overlapping_bodies():
		direction = Vector3(-1,0,0)
	elif player in up.get_overlapping_bodies():
		direction = Vector3(0,0,1)
	elif player in down.get_overlapping_bodies():
		direction = Vector3(0,0,-1)
	else:
		direction = Vector3.ZERO
	move_and_slide(direction*speed*delta, Vector3.UP)
