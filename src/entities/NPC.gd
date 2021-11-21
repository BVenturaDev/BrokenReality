extends StaticBody

export (String, "intro", "respawn", "mirror", "push", "gun", "win") var dialog : String

onready var dialog_intro = Dialogic.start("Intro") 
onready var dialog_respawn = Dialogic.start("Respawn") 
onready var dialog_mirror = Dialogic.start("Mirror") 
onready var dialog_push = Dialogic.start("Push") 
onready var dialog_gun = Dialogic.start("Gun") 
onready var dialog_win = Dialogic.start("Win") 

var rotation_angle = 45
var inverted := false

onready var player = get_parent().get_parent().find_node("Player")
onready var sprite = $AnimatedSprite3D
onready var hitbox = $HitBox
onready var sm =$WorldModeSM

func _input(event: InputEvent) -> void:
	if player in hitbox.get_overlapping_bodies():
		if Input.is_action_just_pressed("left_click"): 
			match dialog:
				"intro":
					add_child(dialog_intro)
					player.has_attack = true
				"respawn":
					add_child(dialog_respawn)
				"mirror":
					add_child(dialog_mirror)
				"push":
					add_child(dialog_push)
					player.has_push = true
				"gun":
					add_child(dialog_gun)
					player.has_gun = true
				"win":
					add_child(dialog_win)
				


func _process(delta: float) -> void:
	if !inverted and sm.state == sm.states.inverted:
		inverted = true
		sprite.play("inverted")
	if inverted and sm.state == sm.states.normal: 
		inverted = false
		sprite.play("normal")





