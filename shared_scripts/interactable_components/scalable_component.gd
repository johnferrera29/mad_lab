class_name ScalableComponent
extends Node
## A component that enables a particular [member target] to be resized by a [ResizerDiscProjectile].
##
## Use this component with composition.


## Signal emitted once target has been scaled.
signal scaled(new_scale: Vector2)

## Determines how fast the scaling animation happens in seconds.
const _SCALING_TIME := 0.2

## Target node that contains the [Sprite2D] and [CollisionShape2D] nodes that will be scaled.
@export var target: Node2D
## Factor to shrink based from original scale. Use positive values only.
@export var shrink_factor: float = 1.0
## Factor to enlarge based from original scale. Use positive values only.
@export var enlarge_factor: float = 1.0
## Flag whether to instantly scale the collision layer instead of tweening it.
## Useful for triggers and switches.
@export var instantly_scale_collision: bool

## The current scaling mode of the target.
var current_scale_mode: Enums.ScaleMode = Enums.ScaleMode.RESET
## Flag to temporarily prevent the target object from being scaled by a [ResizerDiscProjectile].
var is_unscalable: bool

var _scaling_audio_resource = preload("res://shared_resources/audio/scaling.ogg")
var _scaling_audio: AudioStreamPlayer2D


func _ready() -> void:
	_set_initial_scale_mode()
	_add_scaling_audio()


## Resizes the target based on the mode provided.
func scale(mode: Enums.ScaleMode) -> void:
	if mode == current_scale_mode or is_unscalable:
		return

	match mode:
		Enums.ScaleMode.SHRINK:
			_shrink(shrink_factor)
		Enums.ScaleMode.ENLARGE:
			_enlarge(enlarge_factor)
		Enums.ScaleMode.RESET:
			_reset_scale()
	
	current_scale_mode = mode


## Shrinks target by [param factor]. Negative values will be ignored.
func _shrink(factor: float) -> void:
	if (factor <= 0.0) or is_unscalable: return
	
	_scaling_audio.pitch_scale = 4.0
	_scaling_audio.play()

	_apply_scale(Vector2.ONE / factor)


## Enlarges target by [param factor]. Negative values will be ignored.
func _enlarge(factor: float) -> void:
	if (factor <= 0.0) or is_unscalable: return

	_scaling_audio.pitch_scale = 2.0
	_scaling_audio.play()

	_apply_scale(Vector2.ONE * factor)


## Resets the scale to original value.
## TODO: Possible deprecation since not being used.
func _reset_scale() -> void:
	if is_unscalable: return
	
	_scaling_audio.pitch_scale = 3.0
	_scaling_audio.play()

	_apply_scale(Vector2.ONE)


## Apply the scaling to target's [Sprite2D] and [CollisionShape2D].
## If [member target.sprite] and [member target.collision_shape] not present, will attempt to find them from its children nodes.
## Doing this since updating the target's (parent) scale introduces some issues with collision.
func _apply_scale(new_scale: Vector2) -> void:
	var target_sprite := target.sprite as Sprite2D
	var target_collision_shape := target.collision_shape as CollisionShape2D

	# Attempt to find the sprite and collision shape in the target's children.
	if not (target_sprite and target_collision_shape):
		for child in target.get_children():
			var collision_shape := child as CollisionShape2D
			if collision_shape:
				target_collision_shape = collision_shape

			var sprite := child as Sprite2D
			if sprite:
				target_sprite = sprite
	
	# Reset the sprite material to also reset target highlighting.
	target.sprite.material = null

	# Animate scaling
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(target_sprite, "scale", new_scale, _SCALING_TIME)
	
	if instantly_scale_collision:
		target_collision_shape.scale = new_scale
	else:
		tween.tween_property(target_collision_shape, "scale", new_scale, _SCALING_TIME)
	
	scaled.emit(new_scale)


## Add scaling audio to the target.
func _add_scaling_audio() -> void:
	_scaling_audio = AudioStreamPlayer2D.new()
	_scaling_audio.stream = _scaling_audio_resource
	_scaling_audio.max_distance = 500.0

	target.add_child.call_deferred(_scaling_audio)


## Determines the initial scale_mode based on shrink / enlarge factor
func _set_initial_scale_mode() -> void:
	if shrink_factor == 1.0:
		current_scale_mode = Enums.ScaleMode.SHRINK
	elif enlarge_factor == 1.0:
		current_scale_mode = Enums.ScaleMode.ENLARGE
	else:
		current_scale_mode = Enums.ScaleMode.RESET
