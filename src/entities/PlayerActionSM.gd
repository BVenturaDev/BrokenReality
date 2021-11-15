extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("run")
	add_state("jump")
	add_state("attack")
	add_state("shoot")
	add_state("push")
	call_deferred("set_state", states.idle)

func _input(event: InputEvent) -> void:
	if [states.idle, states.walk, states.run].has(state):
		if Input.is_action_just_pressed("left_click"):
			parent._attack()
			state = states.attack
			yield(get_tree().create_timer(1.0), "timeout")
			state = states.idle
		if Input.is_action_just_pressed("right_click"):
			parent._shoot()
			state = states.shoot
			yield(get_tree().create_timer(1.0), "timeout")
			state = states.idle
		if Input.is_action_just_pressed("jump"):
			parent.velocity.y += parent.jump_height

func _state_logic(delta):
	if ![states.attack, states.shoot,].has(state):
		parent._movement(delta)
		if state == states.jump:
			parent.velocity.y += parent.gravity * delta

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				return states.jump
			elif parent.velocity.x != 0 or parent.velocity.z != 0:
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				return states.jump
			elif parent.velocity.x == 0 and parent.velocity.z == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match state:
		states.attack:
			pass

func _exit_state(old_state, new_state):
	pass
