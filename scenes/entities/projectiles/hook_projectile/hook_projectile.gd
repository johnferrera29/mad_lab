class_name HookProjectile
extends Projectile 
## A projectile hooks onto an anchor.
##
## Hooks into an [InteractableObject] that contain a [AnchorComponent].
## TODO: Update to accomodate multitudes of changes. Curerntly will throw error.


## A reference to the projectile's spawn point.
## Used for retracting the hook.
var projectile_spawn_point: Node2D
## Speed of projectile retraction when no anchor is detected.
var projectile_retraction_speed: float
## An reference to an awaitable callable that starts the grappling towards the anchor.
var start_grappling: Callable

# Boolean flags for determing the state of the hook projectile.
var _is_retracting: bool
var _is_hooked: bool

@onready var _rope_line := $RopeLine as Line2D


func _physics_process(delta: float) -> void:
	if not _is_hooked:
		if not _is_retracting and not _lifespan_timer.is_stopped():
			# Move the projectile towards initial velocity while not yet retracting and lifespan timer not yet expired.
			print("launching...")
			_move_projectile(delta, projectile_velocity)
		else:
			# Once timer expires, start retraction.
			if not _is_retracting:
				print("start retraction -> lifespan up!")
				start_retraction()
		
			# Retracts projectile and recalculates velocity every time since actor may be moving.
			print("retracting...")
			var retraction_velocity := projectile_retraction_speed * global_position.direction_to(projectile_spawn_point.global_position)
			_move_projectile(delta, retraction_velocity)
	else:
		# Just draw the rope if grappling since actor  is moving towards anchor.
		_draw_rope(projectile_spawn_point.global_position, global_position)


## Starts retracting the projectile.
## Usually done if no anchor is detected or projectile lifespan has ended.
func start_retraction() -> void:
	_is_retracting = true


## Moves the hook projectile at a certain velocity.
func _move_projectile(delta: float, velocity: Vector2) -> void:
	global_position += velocity * delta

	_draw_rope(projectile_spawn_point.global_position, global_position)


# Draws the rope to the hook.
func _draw_rope(start: Vector2, end: Vector2) -> void:
	_rope_line.points = PackedVector2Array([
		start,
		end
	])


func _on_body_entered(body: Node2D) -> void:
	if _is_retracting and body is Player:
		destroy()
		return
	
	var interactable_object := body as InteractableObject

	if not _is_retracting and interactable_object and interactable_object.anchor_component:
		# Hook is now anchored, so start grappling.
		print("hooked to anchor")
		_is_hooked = true
		await start_grappling.call(interactable_object.anchor_component.target)
		destroy()
	else:
		# TODO: Handle collision via collision layers to prevent colliding with [Player] and [GrapplingHook]
		if not (body as Player) and not (body as GrapplingHook):
			if not _is_retracting:
				print("start retraction -> hit an object!")
				start_retraction()
