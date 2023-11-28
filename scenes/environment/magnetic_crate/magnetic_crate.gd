class_name MagneticCrate
extends InteractableObject
## A crate that emits a magnetic field which reflects certain types of projectile.
##
## Currently reflecting [ResizerDiscProjectile], [BombProjectile].


## Determines if crate emits a magnetic field that will reflect projectiles.
## Currently reflecting [ResizerDiscProjectile], [BombProjectile].
var is_magnetic: bool = true:
	set(new_value):
		_toggle_magnetic_field_fx(new_value)
		is_magnetic = new_value

@onready var magnetic_field_fx := $MagneticFieldParticle as GPUParticles2D
@onready var magnetic_field_collision_shape := $MagneticField/CollisionShape2D
@onready var magnetic_audio := $MagneticAudio as AudioStreamPlayer2D


func _ready() -> void:
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	animator = $AnimationPlayer

	_init_connections()


## Initializes dynamic signal connections.
func _init_connections() -> void:
	if scalable_component:
		scalable_component.scaled.connect(_on_scaled)


func _reflect_projectile(projectile: Projectile) -> void:
	# Reflect only valid projectiles.
	if not projectile or not _check_if_reflectable_projectile(projectile):
		return

	Utils.ProcessUtils.toggle_processing(projectile, false)

	var bounce_direction := global_position.direction_to(projectile.global_position)
	var new_velocity := bounce_direction * projectile.projectile_velocity.length()
	var new_rotation := global_position.angle_to_point(projectile.global_position)

	projectile.rotation = new_rotation
	projectile.projectile_velocity = new_velocity

	Utils.ProcessUtils.toggle_processing(projectile, true)


# TODO: Add a magnetic / reflectable property to the projectile specific class instead of manually specifying here.
func _check_if_reflectable_projectile(projectile: Projectile) -> bool:
	if projectile is ResizerDiscProjectile or projectile is BombProjectile:
		return true

	return false


## Toggles the magnetic field visual effect.
func _toggle_magnetic_field_fx(flag: bool) -> void:
	magnetic_field_fx.emitting = flag
	
	if flag:
		magnetic_audio.play()
	else:
		magnetic_audio.stop()
	
	var animation_player = animator as AnimationPlayer
	if flag and not animation_player.is_playing():
		animation_player.play("jiggle")
	else:
		animation_player.stop()


# Signal callbacks
func _on_magnetic_field_area_entered(area: Area2D) -> void:
	if is_magnetic:
		_reflect_projectile(area as Projectile)


func _on_scaled(new_scale: Vector2) -> void:
	magnetic_field_collision_shape.scale = new_scale
	magnetic_field_fx.scale = new_scale
