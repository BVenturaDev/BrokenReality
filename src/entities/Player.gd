extends KinematicBody


var velocity : Vector3 
var direction : Vector2
var acceleration = 10
var max_speed = 50
var friction = 10
var gravity = -50
var rotation_angle = 45
var jump_height = 15
var bullet : PackedScene = preload("res://scenes/entities/Bullet.tscn")

onready var camera_rotator = $CameraRotator
onready var sprite = $Sprite3D
onready var hitbox = $HitBox
onready var light := get_parent().find_node("DirectionalLight") 
onready var vp : Viewport = get_viewport()
onready var vp_size : Vector2 = get_viewport().size
onready var vp_slope : float = vp_size.y/vp_size.x 


func _movement(delta) -> void:
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	velocity.z = lerp(0, direction.normalized().y * max_speed * 1.5, acceleration * delta)
	velocity.x = lerp(0, direction.normalized().x * max_speed, acceleration * delta)
	
	if direction == Vector2.ZERO:
		velocity.z = lerp(velocity.z, 0, friction * delta)
		velocity.x = lerp(velocity.x, 0, friction * delta)
		
	if is_on_ceiling():
		velocity.y = -0.1
		
	move_and_slide(velocity, Vector3.UP)

func _attack() -> void:
	if vp.get_mouse_position().x > vp_size.x/2 :
		hitbox.translation.x = 2
	if vp.get_mouse_position().x < vp_size.x/2 :
		hitbox.translation.x = -2
	var objectives = hitbox.get_overlapping_bodies()
	for objective in objectives:
		if objective.has_method("hitted"):
			objective.hitted()

func _shoot() -> void:
	var new_bullet = bullet.instance()
	new_bullet.global_transform = self.global_transform
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(1,0,0)
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(-1,0,0)
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(0,0,-1)
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(0,0,1)
	get_tree().current_scene.add_child(new_bullet)

