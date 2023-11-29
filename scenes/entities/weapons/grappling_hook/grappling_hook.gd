class_name GrapplingHook
extends Weapon
## A grappling hook that launches a [HookProjectile] that when anchored, starts moving the player towards it.
##
## Target object must extend an [InteractableObject] and contains a [AnchorComopnent].


## The actor that will be moved towards the anchor.
@export var actor: Player
## Speed of grappling once projectile hooked to an anchor.
@export var grappling_speed: float
## Speed of projectile retraction when no anchor is detected.
@export var projectile_retraction_speed: float

var _projectile_ref: HookProjectile

## Determines the spawn position and rotation of the projectile.
@onready var targeting_system := $TargetingSystem as TargetingSystem
@onready var projectile_launcher := $ProjectileLauncher as ProjectileLauncher
@onready var projectile_spawn_point := $ProjectileSpawnPoint as Marker2D


func _input(event: InputEvent) -> void:
	# TODO: Add release grapple hook input that will:
	# 1. Stops and releases the grappling hook if already hooked to anchor.
	# 2. Immediately retracts the hook projectile.

	## Launch a projectile only if there is no hook inside
	if Input.is_action_just_pressed("interact") and not is_instance_valid(_projectile_ref):
		var target_position := get_global_mouse_position()
		var projectile_velocity := projectile_launcher.launch_speed * global_position.direction_to(target_position)
		var projectile := projectile_launcher.create_projectile(
			projectile_spawn_point.global_position,
			projectile_spawn_point.rotation,
			projectile_velocity,
			projectile_launcher.projectile_lifespan
		) as HookProjectile

		# Custom HookProjectile properties.
		projectile.projectile_spawn_point = projectile_spawn_point
		projectile.projectile_retraction_speed = projectile_retraction_speed
		projectile.start_grappling = _start_grappling
		
		projectile_launcher.launch_projectile(projectile)

		_projectile_ref = projectile


## Awaitable function that starts moving the actor towards anchor until it reaches it.
func _start_grappling(anchor: Node2D) -> void:
	var state := actor.grappling_state
	var msg := state.create_state_params(anchor, grappling_speed)

	actor.state_machine.change_state(state, msg)
	
	await actor.grappling_state.actor_fell


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	if target and target.anchor_component:
		targeting_system.toggle_shader_effect(target.anchor_component.sprite, true)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	if target and target.anchor_component:
		targeting_system.toggle_shader_effect(target.anchor_component.sprite, false)
