class_name HookProjectile
extends Projectile 
## A projectile hooks onto an [AnchorComponent].
##
## Hooks into an [InteractableObject] that contains a [AnchorComponent].


var spawn_point_ref: Node2D
# var actor_ref: Player
var launch_callable: Callable
var retraction_speed: float

var _is_retracting: bool
var _is_hooked: bool
var _is_grappling: bool

@onready var rope_line := $RopeLine as Line2D


func _physics_process(delta: float) -> void:
	# if _is_destroyed: return
	
	if not _is_hooked:
		if not _is_retracting and not _lifespan_timer.is_stopped():
			# Move towards a specified velocity while not yet collided with another body or lifespan timer not yet up.
			print("launching...")
			global_position += projectile_velocity * delta
			draw_rope(spawn_point_ref.global_position, global_position)
		else:
			# Time is up, if not hooked and not yet retracting, start retraction.
			if not _is_hooked and not _is_retracting :
				print("start retraction -> lifespan up!")
				_is_retracting = true
		
			# Retract rope.
			if _is_retracting:
				retract_projectile(delta)
				draw_rope(spawn_point_ref.global_position, global_position)
	elif _is_grappling:
		draw_rope(spawn_point_ref.global_position, global_position)


## Retracts projectile. Recalculates retractiony velocity everytime since actor may be moving.
func retract_projectile(delta: float) -> void:
	print("retracting...")
	var retraction_velocity := retraction_speed * global_position.direction_to(spawn_point_ref.global_position)
	
	global_position += retraction_velocity * delta

	# TODO: Destroy projectile on collision with player

## Launch towards anchor.
func launch_actor(anchor: Node2D) -> void:
	print("actor launched towards anchor")
	_is_grappling = true
	await launch_callable.call(anchor)
	destroy()


	# TODO: Destroy projectile on collision with anchor

# func launch_actor(anchor: Node2D) -> void:
# 	var distance := actor.global_position.distance_to(anchor.global_position)
# 	var grappling_speed := (distance * 2.0) / grappling_time_to_anchor
	
# 	var state := actor.grappling_state
# 	var msg := state.create_state_params(anchor, grappling_speed)

# 	actor.state_machine.change_state(state, msg)
	
# 	await actor.grappling_state.actor_fell

# 	# TODO: Replace with actual method
# 	_on_grappling_stopped()

# Draws the rope to the hook.
func draw_rope(start: Vector2, end: Vector2) -> void:
	rope_line.points = PackedVector2Array([
		start,
		end
	])

func _on_body_entered(body: Node2D) -> void:
	if _is_retracting and body is Player:
		destroy()
		return
	
	var interactable_object := body as InteractableObject

	if not _is_retracting and interactable_object and interactable_object.anchor_component:
		print("hooked to anchor")
		_is_hooked = true
		await launch_actor(interactable_object.anchor_component.target)
	else:
		# TODO: Handle collision via collision layers to prevent colliding with [Player] and [BombLauncher]
		# For now, ignoring manually destroy if body is not [Player] or [BombLauncher].
		if not (body as Player) and not (body as GrapplingHook):
			if not _is_retracting:
				print("start retraction -> hit an object!")
				_is_retracting = true


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
