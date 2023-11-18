class_name Projectile
extends Area2D
## Base class for projectiles launched by [ProjectileLauncher].


## Node that handles the projectile's animation, if any.
## Currently supports [AnimatedSprite2D] and [AnimationPlayer].
@export var animator: Node
## The name of the animation to be played once projectile is destroyed.
@export var destroy_animation_name: String

## The velocity of the projectile.
var projectile_velocity: Vector2
## The lifespan of the projectile in seconds before it's automatically destroyed.
var projectile_lifespan: float

var _is_destroyed: bool
var _lifespan_timer: Timer


func _ready() -> void:
	_init_timer()


func _physics_process(delta: float) -> void:
	if not _is_destroyed and not _lifespan_timer.is_stopped():
		global_position += projectile_velocity * delta
	else:
		destroy()


func _init_timer() -> void:
	_lifespan_timer = Timer.new()
	_lifespan_timer.name = "ProjectileLifespanTimer"
	_lifespan_timer.autostart = true
	_lifespan_timer.one_shot = true
	_lifespan_timer.wait_time = projectile_lifespan
	
	add_child(_lifespan_timer)


## Destroys the projectile. This will play the destroy animation if configured.
func destroy() -> void:
	_is_destroyed = true
	await Utils.AnimationUtils.play_animation(animator, destroy_animation_name)
	queue_free()
