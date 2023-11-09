extends PlayerState


#region State Methods
func state_physics_process(delta: float) -> void:
	# Player is falling.
	if not player.is_on_floor():
		transition_to(self, "air")
	
	# Player jump.
	if Input.is_action_just_pressed("jump"):
		transition_to(self, "air", {jump = true})
	
	# Move player based on input direction.
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		player.velocity.x = direction * player.movement_speed
	else:
		# Player Idle
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_speed)
		transition_to(self, "idle")

	player.move_and_slide()
#endregion
