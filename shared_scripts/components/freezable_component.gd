class_name FreezableComponent
extends Node
## A component that allows [member target] to be frozen by [FreezeRay].
##
## Use this component with composition.


## Target node whose built-in processing callbacks will be stopped by [member freeze_time] seconds.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
## If sprite is an [AnimatedSprite2D], will stop animation when frozen.
@export var sprite: Node2D
## Target's [AnimationPlayer] if any. Will stop animation when  frozen.
@export var animator: AnimationPlayer
## Time it takes to before thawing out in seconds.
## During this time, [method _process] and [method _physics_process] callbacks will be stopped.
@export_range(0.0, 99.0, 0.1) var freeze_time: float

## Flag to prevent double freezing.
var is_frozen: bool


func _ready() -> void:
	# Validate the export variables.
	assert(sprite is Sprite2D or sprite is AnimatedSprite2D, "Export variable [sprite] must be of Sprite2D or AnimatedSprite2D")
