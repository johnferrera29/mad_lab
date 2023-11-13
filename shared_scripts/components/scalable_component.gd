class_name ScalableComponent
extends Node
## A component that enables a particular [member target] to be scaled.
##
## Use this component with composition.


## Target node that will be scaled.
@export var target: Node2D
## Factor to shrink based from original scale. Use positive values only.
@export var shrink_factor: float
## Factor to enlarge based from original scale. Use positive values only.
@export var enlarge_factor: float

var _original_scale: Vector2


func _ready() -> void:
	_original_scale = target.scale


## Shrinks target by [param factor]. Negative values will be ignored.
func shrink(factor: float) -> void:
	if (factor < 0.0): return
	target.scale = _original_scale / factor


## Enlarges target by [param factor]. Negative values will be ignored.
func enlarge(factor: float) -> void:
	if (factor < 0.0): return
	target.scale = _original_scale * factor


func reset_scale() -> void:
	target.scale = _original_scale
