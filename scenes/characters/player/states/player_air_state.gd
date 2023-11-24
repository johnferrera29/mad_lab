class_name PlayerAirState
extends State


signal actor_idle
signal actor_ran

@export var actor: Player
@export var animator: AnimatedSprite2D
@export var jump_buffer_timer: Timer
@export var coyote_timer: Timer

var _was_on_floor: bool
var _is_jumping: bool


func _ready() -> void:
	# Apply actor specified jump buffer and coyote time.
	# Otherwise, will use the wait time specifed in Nodes.
	if actor.jump_buffer:
		jump_buffer_timer.wait_time = actor.jump_buffer
	if actor.coyote_time:
		coyote_timer.wait_time = actor.coyote_time


func state_enter(msg: Dictionary = {}) -> void:
	if msg.has("should_jump"):
		jump(actor.jump_force)
		actor.move_and_slide()


func state_handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if not coyote_timer.is_stopped():
			coyote_timer.stop()
			jump(actor.jump_force)
		else:
			jump_buffer_timer.start()


func state_physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		run(direction, actor.movement_speed)
	else:
		decelerate(actor.movement_speed)
	
	if not actor.is_on_floor():
		check_for_coyote_time(delta)

		# Only apply gravity if actor is falling and coyote timer is inactive.
		if coyote_timer.is_stopped():
			apply_gravity(delta, get_gravity(), actor.terminal_velocity)
		
		_was_on_floor = false
	else:
		check_for_buffered_jump(delta, actor.jump_force)
		
		if is_zero_approx(actor.velocity.y):
			_was_on_floor = true

			# When actor is grounded transition to either idle or run states.
			if is_zero_approx(actor.velocity.x):
				actor_idle.emit()
			else:
				actor_ran.emit()
	
	actor.move_and_slide()


## Adds gravity to actor while falling.
## Limit fall speed by specifying terminal velocity.
func apply_gravity(delta: float, gravity: float, terminal_velocity: float) -> void:
	actor.velocity.y += gravity * delta
	
	# Actor has reached peak height and is now falling.
	if actor.velocity.y >= 0.0:
		_is_jumping = false
		animator.play("fall")
	
	# Applies terminal velocity if specified.
	if terminal_velocity and actor.velocity.y > terminal_velocity:
		print("apply terminal velocity")
		actor.velocity.y = terminal_velocity


## Gets either the actor's [member jump_gravity] or [member fall_gravity].
func get_gravity() -> float:
	return actor.jump_gravity if actor.velocity.y < 0.0 else actor.fall_gravity


## Add an upwards force to the actor.
func jump(force: float) -> void:
	actor.velocity.y = -force
	_is_jumping = true
	animator.play("jump")


## Checks for a buffered jump and executes [method jump] with a [param force].
func check_for_buffered_jump(delta: float, force: float) -> bool:
	if not jump_buffer_timer.is_stopped():
		jump_buffer_timer.stop()
		jump(force)
		return true
	
	return false


# Checks if actor is previously on floor and not jumping. If true activate coyote time.
func check_for_coyote_time(delta: float) -> bool:
	if _was_on_floor and not _is_jumping:
		coyote_timer.start()
		return true

	return false


## Move the actor horizontally to the specified [param direction] at a particular [param speed].
func run(direction: float, speed: float) -> void:
	actor.velocity.x = direction * speed
	animator.flip_h = direction == -1


## Deccelerates the actor by [param speed] towards an optional [param target_speed].
## By default decelerates towards zero.
func decelerate(speed: float, target_speed: float = 0.0) -> void:
	actor.velocity.x = move_toward(actor.velocity.x, target_speed, speed)


## A method that returns a Dictionary for initializing behavior of the [PlayerAirState] on [method state_enter].
## 
## [param should_jump]. Flag for initiating a jump upon entering state.
func create_state_params(should_jump: bool) -> Dictionary:
	return {
		"should_jump": should_jump
	}
