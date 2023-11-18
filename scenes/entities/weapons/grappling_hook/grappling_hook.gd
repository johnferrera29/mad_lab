class_name GrapplingHook
extends Weapon
## A grappling hook that launches the actor to a specified target.
##
## Target object must extend an [InteractableObject] and contains a [AnchorComopnent].


@export var actor: Player
## Time it takes for actor to reach target anchor in seconds.
## The speed of the grappling will depend on this and the distance between actor and anchor.
@export_range(0.1, 1.0, 0.1) var grappling_time_to_anchor: float = 0.5

## Determines the spawn position and rotation of the projectile.
@onready var targeting_system := $TargetingSystem as TargetingSystem
@onready var projectile_launcher := $ProjectileLauncher as ProjectileLauncher
@onready var projectile_spawn_point := $ProjectileSpawnPoint as Marker2D


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		print("Launch grappling hook!")
		var target_position := get_global_mouse_position()
		var projectile_velocity := projectile_launcher.launch_speed * global_position.direction_to(target_position)
		var projectile := projectile_launcher.create_projectile(
			projectile_spawn_point.global_position,
			projectile_spawn_point.rotation,
			projectile_velocity,
			projectile_launcher.projectile_lifespan
		) as HookProjectile

		# Custom HookProjectile properties.
		projectile.spawn_point_ref = projectile_spawn_point
		projectile.launch_callable = launch_actor
		projectile.retraction_speed = projectile_launcher.launch_speed * 2.0 # TODO: Improve by using grappling_time_to_anchor computation. 

		projectile_launcher.launch_projectile(projectile)


## Launches actor towards anchor.
func launch_actor(anchor: Node2D) -> void:
	var distance := actor.global_position.distance_to(anchor.global_position)
	var grappling_speed := (distance * 2.0) / grappling_time_to_anchor
	
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
