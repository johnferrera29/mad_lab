class_name BombLauncher
extends Launcher
## A bomb launcher... that launches bombs. Launches a [BombProjectile] towards a target position.
##
## Target object must extend an [InteractableObject] and contain a [BreakableComponent].


## Determines the spawn position and rotation of the projectile.
@export var projectile_spawn_point: Marker2D


func _on_targeting_system_target_locked(target_position: Vector2) -> void:
	var projectile_velocity := launch_speed * global_position.direction_to(target_position)
	var projectile := create_projectile(projectile_spawn_point.global_position, projectile_spawn_point.rotation, projectile_velocity, projectile_lifespan)
	
	launch_projectile(projectile)
