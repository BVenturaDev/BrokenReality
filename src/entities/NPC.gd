extends StaticBody

export (String, "intro", "respawn", "mirror", "push", "gun", "win") var dialog : String

var rotation_angle = 45
var inverted := false

onready var player = get_parent().get_parent().find_node("Player")
onready var sprite = $AnimatedSprite3D
onready var hitbox = $HitBox
onready var sm =$WorldModeSM

func _input(event: InputEvent) -> void:
	if player in hitbox.get_overlapping_bodies():
		if Input.is_action_just_pressed("left_click") and player.sma.state != player.sma.states.talk:
			player.set_dialog(dialog)
			yield(get_tree().create_timer(0.1), "timeout")
			player.set_talking(true)

func _process(delta: float) -> void:
	if !inverted and sm.state == sm.states.inverted:
		inverted = true
		sprite.play("inverted")
	if inverted and sm.state == sm.states.normal: 
		inverted = false
		sprite.play("normal")



