class_name FreezeRay
extends Weapon
## A gun that fires an ice beam that freezes everything in its path.
##
## "Freezing" in this case is stoping the target's built-in processes (e.g. _physics_process, _input, etc.) and any attached animators.
## Target object must extend an [InteractableObject] and contains a [FreezableComponent].


## Determines the spawn position and rotation of the projectile.
@onready var targeting_system := $TargetingSystem as TargetingSystem
@onready var projectile_launcher := $ProjectileLauncher as ProjectileLauncher
@onready var projectile_spawn_point := $ProjectileSpawnPoint as Marker2D


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		print("Launch ice beam!")
		var target_position := get_global_mouse_position()
		var projectile_velocity := projectile_launcher.launch_speed * global_position.direction_to(target_position)
		var projectile := projectile_launcher.create_projectile(
			projectile_spawn_point.global_position,
			projectile_spawn_point.rotation,
			projectile_velocity,
			projectile_launcher.projectile_lifespan
		)
	
		projectile_launcher.launch_projectile(projectile)


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	if target and target.freezable_component:
		targeting_system.toggle_shader_effect(target.freezable_component.sprite, true)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	if target and target.freezable_component:
		targeting_system.toggle_shader_effect(target.freezable_component.sprite, false)
