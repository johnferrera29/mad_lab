class_name AnchorComponent
extends Node
## A component that allows [member target] to be used as an anchor of [GrapplingHook].
##
## Use this component with composition.


## Target node that will serve as the anchor an actor will move towards.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D


func _ready() -> void:
	# Validate the export variables.
	assert(sprite is Sprite2D or sprite is AnimatedSprite2D, "Export variable [sprite] must be of Sprite2D or AnimatedSprite2D")
