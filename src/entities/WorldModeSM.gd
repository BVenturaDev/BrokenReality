extends StateMachine

onready var player = get_tree().current_scene.find_node("Player").get_node("WorldModeSM")

func _ready() -> void:
	add_state("normal")
	add_state("inverted")
	call_deferred("set_state", states.normal)

func _state_logic(delta):
	if parent.is_in_group("player"):
		parent.sanity = clamp(parent.sanity, 0, parent.max_sanity)
		parent.sprite.modulate.a = parent.sanity/parent.max_sanity
		parent._enemy_sanity_drain(delta)
		if state == states.normal:
			parent._going_sane(delta)
		if state == states.inverted:
			parent._going_insane(delta)

func _get_transition(delta):
	match state:
		states.normal:
			if player.state == states.inverted:
				return states.inverted
			if Input.is_action_just_pressed("ui_accept"):
				return states.inverted
		states.inverted:
			if player.state == states.normal:
				return states.normal
			if Input.is_action_just_pressed("ui_accept"):
				return states.normal
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.inverted:
			parent.sprite.rotate_x(parent.rotation_angle)
			if parent.is_in_group("player"):
				parent.camera_rotator.rotate_x(parent.rotation_angle)
				parent.light.shadow_enabled = true

func _exit_state(old_state, new_state):
	match old_state:
		states.inverted:
			parent.sprite.rotate_x(-parent.rotation_angle)
			if parent.is_in_group("player"):
				parent.light.shadow_enabled = false
				parent.camera_rotator.rotate_x(-parent.rotation_angle)



