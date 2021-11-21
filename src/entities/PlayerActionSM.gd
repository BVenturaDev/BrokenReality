extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("walk_up")
	add_state("walk_down")
	add_state("jump")
	add_state("attack")
	add_state("shoot")
	add_state("talk")
	call_deferred("set_state", states.idle)

func _unhandled_input(event: InputEvent) -> void:
	if [states.idle, states.walk].has(state):
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
			parent.sfx.stream = parent.slash
			parent.sfx.play()
			parent.velocity.y = 0
			parent.velocity.y += parent.jump_height
			state = states.jump
			get_tree().set_input_as_handled()

func _state_logic(delta):
	if [states.idle, states.walk].has(state):
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
			elif parent.velocity.z > 0:
				return states.walk_down
			elif parent.velocity.z < 0:
				return states.walk_up
		states.jump:
			if parent.is_on_floor():
				return states.idle
		states.walk_up:
			if !parent.is_on_floor():
				return states.jump
			elif parent.velocity.z > 0:
				return states.walk_down
			elif parent.velocity.x != 0:
				return states.walk
		states.walk_down:
			if !parent.is_on_floor():
				return states.jump
			elif parent.velocity.z < 0:
				return states.walk_up
			elif parent.velocity.x != 0:
				return states.walk
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.walk:
				parent.sfx.stream = parent.footstep
				parent.sfx.play()
				parent.sprite.play("run")
		states.walk_up:
				parent.sfx.stream = parent.footstep
				parent.sfx.play()
				parent.sprite.play("run_up")
		states.walk_down:
				parent.sfx.stream = parent.footstep
				parent.sfx.play()
				parent.sprite.play("run_down")
		states.idle:
			if parent.has_gun:
				parent.sprite.play("idle_with_gun")
			else:
				parent.sprite.play("idle")

func _exit_state(old_state, new_state):
	match old_state: 
		states.walk:
			parent.sfx.stop()
		states.walk_up:
			parent.sfx.stop()
		states.walk_down:
			parent.sfx.stop()
		
