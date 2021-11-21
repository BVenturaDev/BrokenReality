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

var start_pos = Vector3()
var pos = Vector3()

func _ready():
	start_pos = global_transform.origin
	
func _limit_movement():
	var pos = global_transform.origin
	if pos.x < start_pos.x + left_x:
		pos.x = start_pos.x + left_x
	elif pos.x > start_pos.x + right_x:
		pos.x = start_pos.x + right_x
	
	if pos.z < start_pos.z + up_z:
		pos.z = start_pos.z + up_z
	elif pos.z > start_pos.z + down_z:
		pos.z = start_pos.z + down_z
	global_transform.origin = pos

	
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
	_limit_movement()
