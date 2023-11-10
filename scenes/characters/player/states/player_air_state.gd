class_name PlayerAirState
extends State

signal actor_idle
signal actor_ran

@export var actor: Player
@export var animator: AnimatedSprite2D

var _jump_timer: float


func state_enter(msg: Dictionary = {}) -> void:
	if msg.has("jump"):
		jump(actor.jump_force)
		actor.move_and_slide()


func state_handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		_jump_timer = actor.jump_buffer


func state_physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		run(direction, actor.movement_speed)
	else:
		decelerate(actor.movement_speed)
	
	if not actor.is_on_floor():
		apply_gravity(delta, actor.gravity, actor.gravity_multiplier, actor.terminal_velocity)
	else:
		check_for_buffered_jump(delta, actor.jump_force)
		
		if is_zero_approx(actor.velocity.y):
			# When player is grounded transition to either idle or run states.
			if is_zero_approx(actor.velocity.x):
				actor_idle.emit()
			else:
				actor_ran.emit()
	
	actor.move_and_slide()


## Adds gravity to actor while falling.
func apply_gravity(delta: float, gravity: float, gravity_multiplier: float, terminal_velocity: float) -> void:
	# Apply gravity multiplier once jump force has reached 0. Prevents sticky jump.
	if actor.velocity.y > 0:
		actor.velocity.y += gravity * gravity_multiplier * delta
	else:
		actor.velocity.y += gravity * delta
	
	# Limit fall speed by specifying terminal velocity.
	if actor.velocity.y > terminal_velocity:
		actor.velocity.y = terminal_velocity


## Add an upwards force to the actor.
func jump(force: float) -> void:
	actor.velocity.y = -force


## Checks for a buffered jump and executes [method jump] with a [param force].
func check_for_buffered_jump(delta: float, force: float) -> bool:
	_jump_timer -= delta

	if _jump_timer > 0.0:
		# print("BUFFER JUMP")
		_jump_timer = 0.0
		jump(force)
		return true
	
	return false


## Move the actor horizontally to the specified [param direction] at a particular [param speed].
func run(direction: float, speed: float) -> void:
	actor.velocity.x = direction * speed


## Deccelerates the actor by [param speed] towards an optional [param target_speed].
## By default decelerates towards zero.
func decelerate(speed: float, target_speed: float = 0) -> void:
	actor.velocity.x = move_toward(actor.velocity.x, target_speed, speed)
