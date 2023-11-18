class_name AnchorComponent
extends Node
## A component that allows [member target] to be used as an anchor of [GrapplingHook]'s [HookProjectile].
##
## Use this component with composition.


## Target node that will serve as the anchor an actor will move towards.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D
