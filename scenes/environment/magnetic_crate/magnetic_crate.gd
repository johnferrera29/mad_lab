class_name MagneticCrate
extends InteractableObject
## A crate that emits a magnetic field which reflects certain types of metallic projectile.
##
## Checks if the projectile contains a [member is_metallic].


## Determines if crate emits a magnetic field that will reflect projectiles.
## Checks if the projectile contains a [member is_metallic].
var is_magnetic: bool = true:
	set(new_value):
		_toggle_magnetic_field_fx(new_value)
		if scalable_component: scalable_component.is_unscalable = new_value
		is_magnetic = new_value

@onready var _magnetic_field_fx := $MagneticFieldParticle as GPUParticles2D
@onready var _magnetic_field_collision_shape := $MagneticField/CollisionShape2D as CollisionShape2D
@onready var _magnetic_audio := $MagneticAudio as AudioStreamPlayer2D


func _ready() -> void:
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	animator = $AnimationPlayer
	
	if scalable_component:
		scalable_component.is_unscalable = true
	
	_init_connections()


## Initializes dynamic signal connections.
func _init_connections() -> void:
	if scalable_component:
		scalable_component.scaled.connect(_on_scaled)
	
	if freezable_component:
		freezable_component.froze.connect(_on_froze)
		freezable_component.thawed.connect(_on_thawed)


func _reflect_projectile(projectile: Projectile) -> void:
	# Check if projectile is metallic.
	if not projectile or not ("is_metallic" in projectile and projectile.is_metallic):
		return
	
	Utils.ProcessUtils.toggle_processing(projectile, false)

	var bounce_direction := global_position.direction_to(projectile.global_position)
	var new_velocity := bounce_direction * projectile.projectile_velocity.length()
	var new_rotation := global_position.angle_to_point(projectile.global_position)

	projectile.rotation = new_rotation
	projectile.projectile_velocity = new_velocity

	Utils.ProcessUtils.toggle_processing(projectile, true)


## Toggles the magnetic field visual effect.
func _toggle_magnetic_field_fx(flag: bool) -> void:
	_magnetic_field_fx.emitting = flag
	
	if flag:
		_magnetic_audio.play()
	else:
		_magnetic_audio.stop()
	
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
	_magnetic_field_collision_shape.scale = new_scale
	_magnetic_field_fx.scale = new_scale


func _on_froze() -> void:
	is_magnetic = false


func _on_thawed() -> void:
	is_magnetic = true
