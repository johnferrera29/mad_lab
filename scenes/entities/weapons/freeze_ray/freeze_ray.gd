class_name FreezeRay
extends Weapon
## A gun that fires an ice beam that freezes everything in its path.
##
## "Freezing" in this case is stoping the target's built-in processes (e.g. _physics_process, _input, etc.) and any attached animators.
## Target object must extend an [InteractableObject] and contains a [FreezableComponent].


@onready var sprite := $Sprite2D as Sprite2D
@onready var targeting_system := $TargetingSystem as TargetingSystem
@onready var projectile_launcher := $ProjectileLauncher as ProjectileLauncher
@onready var projectile_spawn_point := $Sprite2D/ProjectileSpawnPoint as Marker2D


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var target_position := get_global_mouse_position()
		var projectile_velocity := projectile_launcher.launch_speed * global_position.direction_to(target_position)
		var projectile := projectile_launcher.create_projectile(
			projectile_spawn_point.global_position,
			targeting_system.target_angle,
			projectile_velocity,
			projectile_launcher.projectile_lifespan
		)

		projectile_launcher.launch_projectile(projectile)


func _physics_process(delta: float) -> void:
	update_sprite_rotation()


## Rotates the sprite based on targeting system angle.
## Assumes sprite is facing towards the right.
func update_sprite_rotation() -> void:
	sprite.rotation = targeting_system.target_angle
	sprite.flip_v = abs(sprite.rotation_degrees) >= 90


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	if target and target.freezable_component:
		targeting_system.toggle_shader_effect(target.sprite, true)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	if target and target.freezable_component:
		targeting_system.toggle_shader_effect(target.sprite, false)
