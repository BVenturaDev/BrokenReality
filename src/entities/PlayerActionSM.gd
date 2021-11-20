extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("run")
	add_state("jump")
	add_state("attack")
	add_state("shoot")
	add_state("push")
	add_state("talk")
	call_deferred("set_state", states.idle)

func _unhandled_input(event: InputEvent) -> void:
	if [states.idle, states.walk, states.run].has(state):
		if Input.is_action_just_pressed("left_click") and parent.has_attack:
			parent._attack()
			state = states.attack
			yield(get_tree().create_timer(0.5), "timeout")
			state = states.idle
			get_tree().set_input_as_handled()
		if Input.is_action_just_released("right_click") and parent.timer.is_stopped() and parent.has_gun:
			parent.aim.visible = false
			parent._shoot()
			parent.timer.start()
			state = states.shoot
			yield(get_tree().create_timer(0.5), "timeout")
			state = states.idle
			get_tree().set_input_as_handled()
		if Input.is_action_just_pressed("jump") and parent.sm.state == parent.sm.states.inverted:
			parent.velocity.y = 0
			parent.velocity.y += parent.jump_height
			state = states.jump
			get_tree().set_input_as_handled()

func _state_logic(delta):
	if [states.idle, states.walk, states.run].has(state):
		if Input.is_action_pressed("right_click") and parent.timer.is_stopped() and parent.has_gun :
			parent.aim.visible = true
			parent._aim()
	
	if ![states.attack, states.shoot, states.talk].has(state):
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
	match new_state:
		states.shoot:
			pass

func _exit_state(old_state, new_state):
	match old_state: 
		states.shoot:
			pass
		
