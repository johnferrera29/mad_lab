class_name PlayerIdleState
extends State


signal actor_ran
signal actor_jumped
signal actor_fell
signal actor_attacked

@export var actor: Player
@export var animator: AnimatedSprite2D


func state_enter(msg: Dictionary = {}) -> void:
	actor.velocity = Vector2.ZERO
	animator.play("idle")


func state_handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		actor_jumped.emit()
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		actor_ran.emit()

	if Input.is_action_just_pressed("interact"):
		actor_attacked.emit()


func state_physics_process(delta: float) -> void:
	if not actor.is_on_floor():
		actor_fell.emit()
	
	actor.move_and_slide()
