class_name BreakableComponent
extends Node
## A component that allows [member target] to be destroyed by [BombLauncher] project [BombProjectile].
##
## Use this component with composition.


## Target node that will be destroyed. In most cases you want to destroy the scene's root or parent node.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D
## Target's [AnimationPlayer] if any that will play the [member destroy_animation_name].
@export var animator: AnimationPlayer
## Name of the target's destroy animation on an [AnimationPlayer] or [AnimatedSprite2D]
@export var destroy_animation_name: String


func _ready() -> void:
	# Validate the export variables.
	assert(sprite is Sprite2D or sprite is AnimatedSprite2D, "Export variable [sprite] must be of Sprite2D or AnimatedSprite2D")


## Destroys the [member target].
func destroy() -> void:
	await _play_destroy_animation(destroy_animation_name)
	target.queue_free()


## Coroutine that plays the destroy animation of a [BreakableComponent].
## Returns a bool depending whether an animation was played or not.
func _play_destroy_animation(animation_name: String) -> bool:
	var animated_sprite := sprite as AnimatedSprite2D
	if animated_sprite and animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
		await animated_sprite.animation_finished

		return true
	
	if animator and animator.has_animation(animation_name):
		animator.play(animation_name)
		await animator.animation_finished

		return true
	
	return false
