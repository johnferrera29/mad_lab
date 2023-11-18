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


## Resizes the target based on the mode provided.
func scale(mode: Enums.ScaleMode) -> void: 
	match mode:
		Enums.ScaleMode.SHRINK:
			shrink(shrink_factor)
		Enums.ScaleMode.ENLARGE:
			enlarge(enlarge_factor)
		Enums.ScaleMode.RESET:
			reset_scale()


## Shrinks target by [param factor]. Negative values will be ignored.
func shrink(factor: float) -> void:
	if (factor < 0.0): return
	target.scale = original_scale / factor


## Enlarges target by [param factor]. Negative values will be ignored.
func enlarge(factor: float) -> void:
	if (factor < 0.0): return
	target.scale = original_scale * factor


## Resets the scale to original value.
func reset_scale() -> void:
	target.scale = original_scale
