class_name PlayerRunState
extends State


signal actor_idle
signal actor_jumped
signal actor_fell

@export var actor: Player
@export var animator: AnimatedSprite2D


func state_physics_process(delta: float) -> void:
	if not actor.is_on_floor():
		actor_fell.emit()
	
	if Input.is_action_just_pressed("jump"):
		actor_jumped.emit()
	
	# Move player based on input direction.
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		actor.velocity.x = direction * actor.movement_speed
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.movement_speed)
		actor_idle.emit()

	actor.move_and_slide()
