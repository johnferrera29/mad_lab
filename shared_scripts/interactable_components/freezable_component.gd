class_name FreezableComponent
extends Node
## A component that allows [member target] to be frozen by [FreezeRay].
##
## Use this component with composition.


## Target node whose built-in processing callbacks will be stopped by [member freeze_time] seconds.
@export var target: Node2D
## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D
## Node that handles the target's animation, if any.
## Currently supports [AnimatedSprite2D] and [AnimationPlayer].
@export var animator: Node
## Time it takes to before thawing out in seconds.
## During this time, [method _process] and [method _physics_process] callbacks will be stopped.
@export_range(0.0, 99.0, 0.1) var freeze_time: float

## Flag to prevent double freezing.
var _is_frozen: bool


# TODO: Toggle built-in processing. Currently only toggling animator.
func freeze() -> void:
	if _is_frozen: return

	print("freeze")
	_is_frozen = true
	Utils.ProcessUtils.toggle_processing(animator, false)
	
	await get_tree().create_timer(freeze_time).timeout
	
	print("unfreeze")
	_is_frozen = false
	Utils.ProcessUtils.toggle_processing(animator, true)
	
	# TODO: Add frozen shader effect.
