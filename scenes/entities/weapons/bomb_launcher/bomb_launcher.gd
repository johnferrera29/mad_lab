class_name BombLauncher
extends Weapon
## A bomb launcher... that launches bombs. Launches a [BombProjectile].
##
## Target object must extend an [InteractableObject] and contain a [BreakableComponent].


@onready var sprite := $Sprite2D as Sprite2D
@onready var targeting_system := $TargetingSystem as TargetingSystem
@onready var projectile_launcher := $ProjectileLauncher as ProjectileLauncher
@onready var projectile_spawn_point := $Sprite2D/ProjectileSpawnPoint as Marker2D
@onready var audio_queue := $AudioQueue as AudioQueue


func _ready() -> void:
	weapon_type = Enums.WeaponType.BOMB_LAUNCHER


func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact_alt")) and projectile_launcher.launch_timer.is_stopped():
		var target_position := get_global_mouse_position()
		var projectile_velocity := projectile_launcher.launch_speed * global_position.direction_to(target_position)
		var projectile := projectile_launcher.create_projectile(
			projectile_spawn_point.global_position,
			targeting_system.target_angle,
			projectile_velocity,
			projectile_launcher.projectile_lifespan
		)

		projectile_launcher.launch_projectile(projectile)
		
		audio_queue.play_sound()


func _physics_process(delta: float) -> void:
	update_sprite_rotation()


## Rotates the sprite based on targeting system angle.
## Assumes sprite is facing towards the right.
func update_sprite_rotation() -> void:
	sprite.rotation = targeting_system.target_angle
	sprite.flip_v = abs(sprite.rotation_degrees) >= 90


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	if target and target.breakable_component:
		targeting_system.toggle_shader_effect(target.sprite, true)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	if target and target.breakable_component:
		targeting_system.toggle_shader_effect(target.sprite, false)
