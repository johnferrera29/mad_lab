extends PlayerState


#region State Methods
func state_enter(msg := {}) -> void:
	player.velocity = Vector2.ZERO


func state_physics_process(delta: float) -> void:
	# Player is falling.
	if not player.is_on_floor():
		transition_to(self, "air")
	
	# Player jump.
	if Input.is_action_just_pressed("jump"):
		transition_to(self, "air", {jump = true})
	
	# Player run.
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		transition_to(self, "run")
#endregion