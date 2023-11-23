class_name BreakableComponent
extends Node
## A component that allows [member target] to be destroyed by [BombProjectile].
##
## Use this component with composition.


## Target node that will be destroyed. In most cases you want to destroy the scene's root or parent node.
@export var target: Node2D


## Destroys the [member target].
func destroy() -> void:
	target.queue_free()
