class_name ScaleGun
extends Weapon
## A gun that fires off a [ResizerDiscProjectile] that shrink or enlarge an object.
##
## Target object must extend an [InteractableObject] and contain a [ScalableComponent].


## The currently selected scale mode. Defaults to [enum Enums.ScaleMode.SHRINK]
var current_mode := Enums.ScaleMode.SHRINK

## Determines the order when changing weapon mode.
var _scale_modes: Array[Enums.ScaleMode] = [
	Enums.ScaleMode.SHRINK,
	Enums.ScaleMode.ENLARGE,
	Enums.ScaleMode.RESET
]

@onready var sprite := $Sprite2D as Sprite2D
@onready var targeting_system := $TargetingSystem as TargetingSystem
@onready var projectile_launcher := $ProjectileLauncher as ProjectileLauncher
@onready var projectile_spawn_point := $Sprite2D/ProjectileSpawnPoint as Marker2D


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("change_weapon_mode"):
		var new_mode = _scroll_through_scale_modes()
		change_scale_mode(new_mode)


	if Input.is_action_just_pressed("interact"):
		var target_position := get_global_mouse_position()
		var projectile_velocity := projectile_launcher.launch_speed * global_position.direction_to(target_position)
		var projectile := projectile_launcher.create_projectile(
			projectile_spawn_point.global_position,
			targeting_system.target_angle,
			projectile_velocity,
			projectile_launcher.projectile_lifespan
		) as ResizerDiscProjectile

		projectile.scale_mode = current_mode

		projectile_launcher.launch_projectile(projectile)


func _physics_process(delta: float) -> void:
	update_sprite_rotation()


## Change the gun's current scale mode.
func change_scale_mode(mode: Enums.ScaleMode) -> void:
	print("Change scale mode: ", Enums.ScaleMode.keys()[mode])
	current_mode = mode
	# TODO: Change the targeting system's shader material based on mode.


## Rotates the sprite based on targeting system angle.
## Assumes sprite is facing towards the right.
func update_sprite_rotation() -> void:
	sprite.rotation = targeting_system.target_angle
	sprite.flip_v = abs(sprite.rotation_degrees) >= 90


## Scrolls through all available modes without going past the last index.
## Order will be based on [member _scale_modes].
func _scroll_through_scale_modes() -> Enums.ScaleMode:
	var max_index := _scale_modes.size()
	var index := _scale_modes.find(current_mode) + 1
	
	if index >= max_index:
		index = 0
	
	return _scale_modes[index]


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	if target and target.scalable_component:
		targeting_system.toggle_shader_effect(target.sprite, true)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	if target and target.scalable_component:
		targeting_system.toggle_shader_effect(target.sprite, false)
