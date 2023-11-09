class_name PlayerAirState
extends State

signal actor_idle
signal actor_ran

@export var actor: Player
@export var animator: AnimatedSprite2D


func state_enter(msg: Dictionary = {}) -> void:
	if msg.has("jump"):
		actor.velocity.y = -actor.jump_force
		actor.move_and_slide()


func state_physics_process(delta: float) -> void:
	# Move player based on direction.
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		actor.velocity.x = direction * actor.movement_speed
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.movement_speed)
	
	# Add gravity to player while falling.
	if not actor.is_on_floor():
		# Apply gravity multiplier once jump force has reached 0. Prevents sticky jump.
		if actor.velocity.y > 0:
			actor.velocity.y += actor.gravity * actor.gravity_multiplier * delta
		else:
			actor.velocity.y += actor.gravity * delta
		
		# Limit fall speed by specifying terminal velocity.
		if actor.velocity.y > actor.terminal_velocity:
			actor.velocity.y = actor.terminal_velocity
	else:
		# When player is grounded transition to either idle or run states.
		if is_zero_approx(actor.velocity.x):
			actor_idle.emit()
		else:
			actor_ran.emit()
	
	actor.move_and_slide()
