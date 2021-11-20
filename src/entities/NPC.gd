extends StaticBody

export (String, "intro", "respawn", "mirror", "push", "gun", "win") var dialog : String

var rotation_angle = 45

onready var player = get_parent().get_parent().find_node("Player")
onready var sprite = $AnimatedSprite3D
onready var hitbox = $HitBox

func _input(event: InputEvent) -> void:
	if player in hitbox.get_overlapping_bodies():
		if Input.is_action_just_pressed("left_click") and player.sma.state != player.sma.states.talk:
			player.set_dialog(dialog)
			player.set_talking(true)
		

