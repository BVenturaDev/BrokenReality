extends StaticBody

onready var dialog_respawn = Dialogic.start("Respawn") 


var rotation_angle = 45
var inverted := false

onready var player = get_parent().get_parent().find_node("Player")
onready var sprite = $AnimatedSprite3D
onready var hitbox = $HitBox
onready var sm =$WorldModeSM

func _input(event: InputEvent) -> void:
	if player in hitbox.get_overlapping_bodies():
		if Input.is_action_just_pressed("left_click"): 
				add_child(dialog_respawn)

				


func _process(delta: float) -> void:
	if !inverted and sm.state == sm.states.inverted:
		inverted = true
		sprite.play("inverted")
	if inverted and sm.state == sm.states.normal: 
		inverted = false
		sprite.play("normal")
