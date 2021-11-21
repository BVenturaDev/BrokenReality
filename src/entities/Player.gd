extends KinematicBody


var velocity : Vector3 
var direction : Vector2
var acceleration = 30
var max_speed = 50
var friction = 10
var gravity = -30
var rotation_angle = 45
var jump_height = 5
var bullet : PackedScene = preload("res://scenes/entities/Bullet.tscn")
var shoot_recoil = 0.0
var aim_lenght = 8
var hitbox_distance = 2.0
var max_sanity = 100
var sanity : float = max_sanity setget set_sanity
var sanity_drop_rate = 0
var sanity_up_rate = 5
var enemy_sanity_drop_rate = 30
var enemy_sanity_distance_trigger = 5
var talking := false setget set_talking
var dialog : String setget set_dialog
var current_dialog
var has_attack := false
var has_push := false
var has_gun := false


onready var camera_rotator = $CameraRotator
onready var sprite = $Sprite
onready var hitbox = $HitBox
onready var aim = $Aim
onready var light := get_parent().find_node("DirectionalLight") 
onready var vp : Viewport = get_viewport()
onready var vp_size : Vector2 = get_viewport().size
onready var vp_slope : float = vp_size.y/vp_size.x 
onready var sm = $WorldModeSM
onready var sma = $PlayerActionSM
onready var timer =  $Timer
onready var respawner = get_parent().get_node("Respawner")
onready var dialog_intro = Dialogic.start("Intro") 
onready var dialog_respawn = Dialogic.start("Respawn") 
onready var dialog_mirror = Dialogic.start("Mirror") 
onready var dialog_push = Dialogic.start("Push") 
onready var dialog_gun = Dialogic.start("Gun") 
onready var dialog_win = Dialogic.start("Win") 
onready var dialog_after_win = Dialogic.start("AfterWin") 
onready var dialog_begin = Dialogic.start("Begin") 
onready var music = $Music
onready var sfx = $SFX
onready var normal_song : AudioStreamSample = preload("res://assets/Music/Noir.wav")
onready var inverted_song : AudioStreamSample = preload("res://assets/Music/Noir_Inversed.wav")
onready var click : AudioStreamSample = preload("res://assets/SFX/Bell_Ring.wav")
onready var grunt : AudioStreamSample = preload("res://assets/SFX/Grunt.wav")
onready var slash : AudioStreamSample = preload("res://assets/SFX/Sword_Slash.wav")
onready var footstep : AudioStreamSample = preload("res://assets/SFX/Footstep.wav")
onready var enemy_hit : AudioStreamSample = preload("res://assets/SFX/Enemy_Hit.wav")
onready var jump : AudioStreamSample = preload("res://assets/SFX/Jump.wav")
onready var warp : AudioStreamSample = preload("res://assets/SFX/Warp.wav")
onready var shoot : AudioStreamSample = preload("res://assets/SFX/Gun_Fire.wav")


func _ready() -> void:
	add_to_group("player")
	music.stream = normal_song
	music.play()
	talking = true
	sma.state = sma.states.talk
	add_child(dialog_begin)
	

func _movement(delta) -> void:
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	velocity.z = lerp(0, direction.normalized().y * max_speed * 1.5, acceleration * delta)
	velocity.x = lerp(0, direction.normalized().x * max_speed, acceleration * delta)
	
	if direction == Vector2.ZERO:
		velocity.z = lerp(velocity.z, 0, friction * delta)
		velocity.x = lerp(velocity.x, 0, friction * delta)
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	if is_on_ceiling():
		velocity.y = -0.1
		
	move_and_slide(velocity, Vector3.UP)

func _attack() -> void:
	sfx.stream = slash
	sfx.play()
	if vp.get_mouse_position().x > vp_size.x/2 :
		hitbox.translation.x =  hitbox_distance 
		sprite.play("attack")
	if vp.get_mouse_position().x < vp_size.x/2 :
		hitbox.translation.x = -hitbox_distance 
		sprite.flip_h = true
		sprite.play("attack")
		yield(get_tree().create_timer(0.5), "timeout")
		sprite.flip_h = false
	var objectives = hitbox.get_overlapping_bodies()
	for objective in objectives:
		if objective.has_method("hitted"):
			objective.hitted()
			if objective in get_tree().get_nodes_in_group("enemies"):
				sfx.stream = enemy_hit
				sfx.play()
			elif !objective in get_tree().get_nodes_in_group("crates"):
				sfx.stream = click
				sfx.play()

func _shoot() -> void:
	sfx.stream = shoot
	sfx.play()
	var new_bullet = bullet.instance()
	new_bullet.global_transform.origin = self.global_transform.origin
	new_bullet.translation = Vector3(new_bullet.translation.x, 0.1, new_bullet.translation.z)
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(1,0,0)
			sprite.play("shoot")
			self.translate(Vector3(-shoot_recoil,0,0))
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(-1,0,0)
			sprite.flip_h = true
			sprite.play("shoot")
			yield(get_tree().create_timer(0.5), "timeout")
			sprite.flip_h = false
			self.translate(Vector3(shoot_recoil,0,0))
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(0,0,-1)
			sprite.play("shoot_up")
			self.translate(Vector3(0,0,shoot_recoil))
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			new_bullet.direction = Vector3(0,0,1)
			sprite.play("shoot_down")
			self.translate(Vector3(0,0,-shoot_recoil))
	get_tree().current_scene.add_child(new_bullet)

func _aim() -> void:
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(aim_lenght,0.1,0) 
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(-aim_lenght,0.1,0)
	if (vp.get_mouse_position().y < vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y < -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(0,0.1,-aim_lenght) 
	if (vp.get_mouse_position().y > vp_slope * vp.get_mouse_position().x 
		and vp.get_mouse_position().y > -vp_slope * vp.get_mouse_position().x + vp.size.y ):
			aim.translation = Vector3(0,0.1,aim_lenght) 

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
			if enemy.detection != true:
				sfx.stream = grunt
				sfx.play()
				enemy.detection = true
		if distance > enemy_sanity_distance_trigger and enemy.detection == true:
			enemy.detection = false


func _on_mirror_entered() -> void:
	sfx.stream = warp
	sfx.play()
	match sm.state:
		sm.states.normal:
			sm.state = sm.states.inverted
			var music_position = music.get_playback_position()
			music.stop()
			music.stream = inverted_song
			music.play(music_position)
		sm.states.inverted:
			sm.state = sm.states.normal
			var music_position = music.get_playback_position()
			music.stop()
			music.stream = normal_song
			music.play(music_position)

func set_sanity(value) -> void:
	sanity = value
	UiInfo.sanity = value
	if sanity == 0:
		sanity = max_sanity
		sm.state = sm.states.normal
		self.global_transform.origin = respawner.global_transform.origin
		print("you dead")

func set_dialog(value) -> void:
	dialog = value
	match dialog:
		"intro":
			current_dialog = dialog_intro
			has_attack = true
		"respawn":
			current_dialog = dialog_respawn
		"mirror":
			current_dialog = dialog_mirror
		"push":
			current_dialog = dialog_push
			has_push = true
		"gun":
			current_dialog = dialog_gun
			has_gun = true
		"win":
			current_dialog = dialog_win




