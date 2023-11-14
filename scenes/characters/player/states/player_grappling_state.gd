class_name PlayerGrapplingState
extends State


signal actor_fell

@export var actor: Player
@export var animator: AnimatedSprite2D

var _anchor: Node2D
var _grappling_launch_force: float
var _grappling_speed: float
var _is_grappling: bool


func state_enter(msg: Dictionary = {}) -> void:
	_is_grappling = false
	
	_anchor = msg.get("anchor")
	_grappling_launch_force = msg.get("grappling_launch_force")
	_grappling_speed = msg.get("grappling_speed")


func state_physics_process(delta: float) -> void:
	# Check if actor has collided with anchor.
	var collision = actor.get_last_slide_collision()
	if collision and collision.get_collider_id() == _anchor.get_instance_id():
		actor_fell.emit()
		return
	
	grapple(_anchor.global_position, _grappling_launch_force, _grappling_speed)

	actor.move_and_slide()


## Launches the actor towards [param anchor_position].
func grapple(anchor_position: Vector2, launch_force: float, speed: float) -> void:
	var direction: Vector2 = (anchor_position - actor.global_position).normalized()
	
	# Apply an initial launch force then a constant speed afterwards.
	if not _is_grappling:
		actor.velocity = direction * launch_force
		_is_grappling = true
	else:
		actor.velocity = direction * speed


## A method that returns a Dictionary for initializing behavior of the [PlayerGrapplingState].
##
## [param anchor]. The target anchor of the grappling hook.
## [param grappling_launch_force]. Initial force applied at launch to give actor boost.
## [param grappling_speed]. The constant speed applied to grappling towards [param anchor].
func create_state_params(
	anchor: Node2D,
	grappling_launch_force: float,
	grappling_speed: float
) -> Dictionary:
	return {
		"anchor": anchor,
		"grappling_launch_force": grappling_launch_force,
		"grappling_speed": grappling_speed,
	}
