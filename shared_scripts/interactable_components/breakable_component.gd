class_name BreakableComponent
extends Node
## A component that allows [member target] to be destroyed by [BombProjectile].
##
## Use this component with composition.


## Target node that will be destroyed. In most cases you want to destroy the scene's root or parent node.
@export var target: Node2D

## Flag to temporarily prevent the target object from being destroyed by a [BombProjectile].
var is_unbreakable: bool


## Destroys the [member target].
func destroy() -> void:
	if not is_unbreakable:
		target.queue_free()
