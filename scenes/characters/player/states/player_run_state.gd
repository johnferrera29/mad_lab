class_name PlayerRunState
extends State


signal actor_idle
signal actor_jumped
signal actor_fell

@export var actor: Player
@export var animator: AnimatedSprite2D

@onready var run_audio := $RunAudio as AudioStreamPlayer


func state_enter(msg: Dictionary = {}) -> void:
	animator.play("run")
	run_audio.play()


func state_exit() -> void:
	run_audio.stop()


func state_handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		actor_jumped.emit()


func state_physics_process(delta: float) -> void:
	if not actor.is_on_floor():
		actor_fell.emit()
	
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		run(direction, actor.movement_speed)
	else:
		decelerate(actor.movement_speed)
		actor_idle.emit()
	
	
	actor.move_and_slide()


## Move the actor horizontally to the specified [param direction] at a particular [param speed].
func run(direction: float, speed: float) -> void:
	actor.velocity.x = direction * speed
	animator.flip_h = direction == -1


## Deccelerates the actor by [param speed] towards an optional [param target_speed].
## By default decelerates towards zero.
func decelerate(speed: float, target_speed: float = 0) -> void:
	actor.velocity.x = move_toward(actor.velocity.x, target_speed, speed)
