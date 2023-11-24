class_name InteractableObject
extends CollisionObject2D
## Virtual base class that exposes different types of interactable components.
##
## Every interactable object that wants to be detected by [TargetingSystem] should inherit this class.


@export_group("Components")
@export var scalable_component: ScalableComponent
@export var anchor_component: AnchorComponent
@export var freezable_component: FreezableComponent
@export var breakable_component: BreakableComponent

## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
var sprite: Node2D
## The target's [CollisionShape2D]
var collision_shape: Node2D
## Node that handles the target's animation, if any.
## Currently supports [AnimatedSprite2D] and [AnimationPlayer].
var animator: Node
