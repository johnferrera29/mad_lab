extends PlayerState


#region State Methods
func state_enter(msg := {}) -> void:
	if msg.has("jump"):
		player.velocity.y = -player.jump_force
		player.move_and_slide()


func state_physics_process(delta: float) -> void:
	# Move player based on direction.
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		player.velocity.x = direction * player.movement_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_speed)
	
	# Add gravity to player while falling
	if not player.is_on_floor():
		# Conditional gravity multiplier once jump force has been applied.
		# Prevents sticky jumps by applying multiplier only after jump force has been exhausted.
		if player.velocity.y > 0:
			player.velocity.y += player.gravity * player.gravity_multiplier * delta
		else:
			player.velocity.y += player.gravity * delta
		
		# Limit terminal velocity
		if player.velocity.y > player.terminal_velocity:
			player.velocity.y = player.terminal_velocity
	else:
		if is_zero_approx(player.velocity.x):
			transition_to(self, "idle")
		else:
			transition_to(self, "run")
	
	player.move_and_slide()
#endregion
