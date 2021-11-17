extends KinematicBody


var velocity : Vector3 
var direction : Vector2
var acceleration = 10
var max_speed = 100
var friction = 10
var gravity = -50
var rotation_angle = 45
var jump_height = 20
var bullet : PackedScene = preload("res://scenes/entities/Bullet.tscn")
var shoot_recoil = 0.0
var aim_lenght = 8
var max_sanity = 100
var sanity : float = max_sanity 
var sanity_drop_rate = 5
var sanity_up_rate = 5
var enemy_sanity_drop_rate = 80
var enemy_sanity_distance_trigger = 8


onready var camera_rotator = $CameraRotator
onready var sprite = $Sprite3D
onready var hitbox = $HitBox
onready var aim = $Aim
onready var light := get_parent().find_node("DirectionalLight") 
onready var vp : Viewport = get_viewport()
onready var vp_size : Vector2 = get_viewport().size
onready var vp_slope : float = vp_size.y/vp_size.x 
onready var mirror = get_parent().get_node("Mirror")
onready var sm = $WorldModeSM
onready var timer =$Timer

func _ready() -> void:
	add_to_group("player")
	mirror.connect("entered", self, "_on_mirror_entered")
	timer.stop()
	var new_dialog = Dialogic.start('First Dialogue') 
	add_child(new_dialog)
	

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
			self.translate(Vector3(-shoot_recoil,0,0))
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(-1,0,0)
			self.translate(Vector3(shoot_recoil,0,0))
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(0,0,-1)
			self.translate(Vector3(0,0,shoot_recoil))
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(0,0,1)
			self.translate(Vector3(0,0,-shoot_recoil))
	get_tree().current_scene.add_child(new_bullet)

func _aim() -> void:
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(aim_lenght,1.4,0) 
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(-aim_lenght,1.4,0)
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(0,1.4,-aim_lenght) 
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(0,1.4,aim_lenght) 

func _going_insane(delta) -> void:
	sanity += -sanity_drop_rate * delta

func _going_sane(delta) -> void:
	sanity += sanity_up_rate * delta

func _enemy_sanity_drain(delta) -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = (self.global_transform.origin - enemy.global_transform.origin).length()
		if distance < enemy_sanity_distance_trigger:
			distance = clamp(distance, 1, enemy_sanity_distance_trigger)
			sanity += - enemy_sanity_drop_rate * delta * 1/distance

func _on_mirror_entered() -> void:
	match sm.state:
		sm.states.normal:
			sm.state = sm.states.inverted
		sm.states.inverted:
			sm.state = sm.states.normal
	


