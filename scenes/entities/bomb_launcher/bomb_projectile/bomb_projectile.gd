class_name BombProjectile
extends Area2D
## A projectile that can be launched via the [BombLauncher].
##
## Destroys an [InteractableObject] that contains a [BreakableComponent].
## Use this component with composition.


## The [AnimatedSprite2D] component that handles animation, if any.
## This will takes precedence over [member animator].
@export var animated_sprite: AnimatedSprite2D
## The [AnimationPlayer] component that handles animation, if any.
## If [member animated_sprite] present, will ignore this.
@export var animator: AnimationPlayer
## Name of the destroy animation on an [AnimationPlayer] or [AnimatedSprite2D]
@export var destroy_animation_name: String

var projectile_velocity: Vector2
var detonation_time: float

var _is_detonated: bool

@onready var _detonation_timer := $DetonationTimer as Timer


func _ready() -> void:
	_detonation_timer.wait_time = detonation_time
	_detonation_timer.start()


func _physics_process(delta: float) -> void:
	if not _is_detonated and not _detonation_timer.is_stopped():
		global_position += projectile_velocity * delta
	else:
		destroy()


func destroy() -> void:
	_is_detonated = true
	await _play_destroy_animation(destroy_animation_name)
	queue_free()


func _play_destroy_animation(animation_name) -> bool:
	if animated_sprite and animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
		await animated_sprite.animation_finished

		return true
	
	if animator and animator.has_animation(animation_name):
		animator.play(animation_name)
		await animator.animation_finished

		return true
	
	return false


func _on_body_entered(body: Node2D) -> void:
	var interactable_object := body as InteractableObject

	if interactable_object and interactable_object.breakable_component:
		interactable_object.breakable_component.destroy()
		destroy()
	else:
		# TODO: Handle collision via collision layers to prevent colliding with [Player] and [BombLauncher]
		# For now, ignoring manually destroy if body is not [Player] or [BombLauncher].
		if not (body as Player) and not (body as BombLauncher):
			destroy()
