class_name PlayerAirState
extends State


signal actor_idle
signal actor_ran

@export var actor: Player
@export var animator: AnimatedSprite2D

# TODO: Convert these timers to actual Node Timer.
var _jump_timer: float
var _coyote_timer: float

var _was_on_floor: bool
var _is_jumping: bool


func state_enter(msg: Dictionary = {}) -> void:
	if msg.has("jump"):
		jump(actor.jump_force)
		actor.move_and_slide()


func state_handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if _coyote_timer > 0.0:
			print("Jump with Coyote time!")
			_coyote_timer = 0.0
			jump(actor.jump_force)
		else:
			_jump_timer = actor.jump_buffer


func state_physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		run(direction, actor.movement_speed)
	else:
		decelerate(actor.movement_speed)
	
	if not actor.is_on_floor():
		check_for_coyote_time(delta)

		# Only apply gravity if coyote time is not active.
		if _coyote_timer <= 0:
			# print("Coyote time over! Apply gravity")
			apply_gravity(delta, get_gravity(), actor.terminal_velocity)
		
		_was_on_floor = false
	else:
		check_for_buffered_jump(delta, actor.jump_force)
		
		if is_zero_approx(actor.velocity.y):
			_was_on_floor = true

			# When player is grounded transition to either idle or run states.
			if is_zero_approx(actor.velocity.x):
				actor_idle.emit()
			else:
				actor_ran.emit()
	
	actor.move_and_slide()


## Adds gravity to actor while falling.
# Limit fall speed by specifying terminal velocity.
func apply_gravity(delta: float, gravity: float, terminal_velocity: float) -> void:
	actor.velocity.y += gravity * delta
	
	if actor.velocity.y >= 0.0:
		_is_jumping = false
	
	if terminal_velocity > 0.0 and actor.velocity.y > terminal_velocity:
		actor.velocity.y = terminal_velocity


## Gets either the jump_gravity or fall_gravity depending on actor's velocity.y
func get_gravity() -> float:
	return actor.jump_gravity if actor.velocity.y < 0.0 else actor.fall_gravity


## Add an upwards force to the actor.
func jump(force: float) -> void:
	actor.velocity.y = -force
	_is_jumping = true


## Checks for a buffered jump and executes [method jump] with a [param force].
func check_for_buffered_jump(delta: float, force: float) -> bool:
	_jump_timer -= delta

	if _jump_timer > 0.0:
		print("BUFFER JUMP")
		_jump_timer = 0.0
		jump(force)
		return true
	
	return false


# Checks if actor is previously on floor and not jumping. If true activate coyote time.
func check_for_coyote_time(delta: float):
	if _was_on_floor and not _is_jumping:
			print("Activate COYOTE TIME")
			_coyote_timer = actor.coyote_time

	_coyote_timer -= delta


## Move the actor horizontally to the specified [param direction] at a particular [param speed].
func run(direction: float, speed: float) -> void:
	actor.velocity.x = direction * speed


## Deccelerates the actor by [param speed] towards an optional [param target_speed].
## By default decelerates towards zero.
func decelerate(speed: float, target_speed: float = 0) -> void:
	actor.velocity.x = move_toward(actor.velocity.x, target_speed, speed)
