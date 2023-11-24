class_name MagneticCrate
extends InteractableObject


## Determines if crate emits a magnetic field that will reflect projectiles.
## Currently reflecting [ResizerDiscProjectile].
var is_magnetic: bool = true:
	set(new_value):
		if not is_magnetic: _toggle_magnetic_field_fx(false)
		is_magnetic = new_value


func _ready() -> void:
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D


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


func _check_if_reflectable_projectile(projectile: Projectile) -> bool:
	# TODO: Add a magnetic / reflectable property to the projectile specific class instead of manually specifying here.
	if projectile is ResizerDiscProjectile:
		return true

	return false


## Toggles the magnetic field visual effect.
func _toggle_magnetic_field_fx(flag: bool) -> void:
	pass # TODO: Implement this method.


func _on_magnetic_field_area_entered(area: Area2D) -> void:
	if is_magnetic:
		_reflect_projectile(area as Projectile)
