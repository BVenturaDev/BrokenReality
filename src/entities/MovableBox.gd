extends KinematicBody

# to limit the movement
export var up_z := -10.0
export var down_z := 10.0
export var left_x := -10.0
export var right_x := 10.0

var direction : Vector3
var speed = 300

onready var left := $Left
onready var right := $Right
onready var up := $Up
onready var down := $Down
onready var player = get_parent().get_parent().get_node("Player")
onready var position = translation



func _process(delta: float) -> void:
	translation.z = clamp(translation.z, position.z + up_z, position.z + down_z)
	translation.x = clamp(translation.x, position.x + left_x, position.x + right_x)
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
