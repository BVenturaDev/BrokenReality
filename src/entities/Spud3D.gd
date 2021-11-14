extends KinematicBody

onready var CamRot = $CamRot
onready var sprite = $Sprite3D

var vel: Vector3 = Vector3()
var accel = 0.99
var max_speed = 30
var friction = 3
var gravity = -20
var rot_angle = 45
var jump_height = 20

var cam_toggle = false

var light

func _ready():
	light = get_parent().find_node("DirectionalLight")

func _physics_process(delta):
	if is_on_ceiling():
		vel.y = -0.1
	
	# Flip the camera if enter is pressed when on floor
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Go from 3D to 2D
		if cam_toggle:
			CamRot.rotate_x(-rot_angle)
			sprite.rotate_x(-rot_angle)
			cam_toggle = false
			if light:
				light.shadow_enabled = false
		# Go from 2D to 3D
		else:
			CamRot.rotate_x(rot_angle)
			sprite.rotate_x(rot_angle)
			cam_toggle = true
			if light:
				light.shadow_enabled = true
	
	# Only jump in 3D and when on floor
	if Input.is_action_just_pressed("jump") and cam_toggle and is_on_floor():
		vel.y += jump_height
	
	# WASD controls
	var in_dir = Vector3()
	in_dir.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	in_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	in_dir = in_dir.normalized()
	vel = vel.linear_interpolate(in_dir * max_speed, accel * delta)
	vel.z = lerp(vel.z, 0, friction * delta)
	vel.x = lerp(vel.x, 0, friction * delta)
	# Apply gravity if not on the floor
	if not is_on_floor():
		vel.y += gravity * delta
	move_and_slide(vel, Vector3.UP)
	
	# Flip sprite when moving -X
	if vel.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
