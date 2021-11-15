extends StateMachine

func _ready() -> void:
	add_state("normal")
	add_state("inverted")
	call_deferred("set_state", states.normal)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		states.normal:
			if Input.is_action_just_pressed("ui_accept"):
				return states.inverted
		states.inverted:
			if Input.is_action_just_pressed("ui_accept"):
				return states.normal
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.inverted:
			parent.camera_rotator.rotate_x(parent.rotation_angle)
			parent.sprite.rotate_x(parent.rotation_angle)
			parent.light.shadow_enabled = true

func _exit_state(old_state, new_state):
	match old_state:
		states.inverted:
			parent.camera_rotator.rotate_x(-parent.rotation_angle)
			parent.sprite.rotate_x(-parent.rotation_angle)
			parent.light.shadow_enabled = false


