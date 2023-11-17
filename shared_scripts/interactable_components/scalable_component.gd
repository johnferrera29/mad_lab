class_name ScalableComponent
extends Node
## A component that enables a particular [member target] to be scaled.
##
## Use this component with composition.


## Target node that will be scaled.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D
## Factor to shrink based from original scale. Use positive values only.
@export var shrink_factor: float
## Factor to enlarge based from original scale. Use positive values only.
@export var enlarge_factor: float

@onready var original_scale: Vector2 = target.scale


func _ready() -> void:
	# Validate the export variables.
	assert(sprite is Sprite2D or sprite is AnimatedSprite2D, "Export variable [sprite] must be of Sprite2D or AnimatedSprite2D")
