class_name BreakableComponent
extends Node
## A component that allows [member target] to be destroyed by [BombProjectile].
##
## Use this component with composition.


## Target node that will be destroyed. In most cases you want to destroy the scene's root or parent node.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D
## Node that handles the target's animation, if any.
## Currently supports [AnimatedSprite2D] and [AnimationPlayer].
@export var animator: Node
## Name of the target's destroy animation on an [AnimationPlayer] or [AnimatedSprite2D]
@export var destroy_animation_name: String


## Destroys the [member target].
func destroy() -> void:
	await Utils.AnimationUtils.play_animation(animator, destroy_animation_name)
	target.queue_free()
