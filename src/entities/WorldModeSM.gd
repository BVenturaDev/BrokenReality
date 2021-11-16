extends StateMachine

# The way of checking if parent == Player is horrible to look at, but it works. Feel free to change it if 
# you can think of anything else.
# we could also have a different state machine for the non-player stuff, that needs to have their
# sprites rotated, but it would be repeated code, i kinda dont like it.


func _ready() -> void:
	add_state("normal")
	add_state("inverted")
	call_deferred("set_state", states.normal)

func _state_logic(delta):
	if parent.has_method("_movement"):
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
			if Input.is_action_just_pressed("ui_accept"):
				return states.inverted
		states.inverted:
			if Input.is_action_just_pressed("ui_accept"):
				return states.normal
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.inverted:
			parent.sprite.rotate_x(parent.rotation_angle)
			if parent.has_method("_movement"):
				parent.camera_rotator.rotate_x(parent.rotation_angle)
				parent.light.shadow_enabled = true

func _exit_state(old_state, new_state):
	match old_state:
		states.inverted:
			parent.sprite.rotate_x(-parent.rotation_angle)
			if parent.has_method("_movement"):
				parent.light.shadow_enabled = false
				parent.camera_rotator.rotate_x(-parent.rotation_angle)



