class_name ScalableComponent
extends Node
## A component that enables a particular [member target] to be scaled.
##
## Use this component with composition.


## Target node that contains the [Sprite2D] and [CollisionShape2D] nodes that will be scaled.
@export var target: Node2D
## Factor to shrink based from original scale. Use positive values only.
@export var shrink_factor: float = 1.0
## Factor to enlarge based from original scale. Use positive values only.
@export var enlarge_factor: float = 1.0

@onready var original_scale: Vector2 = target.scale


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
	_apply_scale(original_scale / factor)



## Enlarges target by [param factor]. Negative values will be ignored.
func enlarge(factor: float) -> void:
	if (factor < 0.0): return
	_apply_scale(original_scale * factor)


## Resets the scale to original value.
func reset_scale() -> void:
	_apply_scale(original_scale)


## Apply the scaling to target's the [Sprite2D] and [CollisionShape2D].
## If [member target.sprite] and [member target.collision_shape] not present, will attempt to find nodes from its children.
## Doing this since updating the target's scale introduces some issues with collision.
func _apply_scale(new_scale: Vector2) -> void:
	if target.sprite and target.collision_shape:
		target.sprite.scale = new_scale
		target.collision_shape.scale = new_scale
	else:
		for child in target.get_children():
			var collision_shape := child as CollisionShape2D
			if collision_shape:
				collision_shape.scale = new_scale

			var sprite := child as Sprite2D
			if sprite:
				sprite.scale = new_scale
