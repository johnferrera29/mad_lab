class_name FreezableComponent
extends Node
## A component that allows [member target] to be frozen by [FreezeRay].
##
## Use this component with composition.
##
## NOTE: Currently only stopping the [member animator] built-in processing.
## We still want the node containing this component to interact with the game world,
## especially if [InteractableObject] contains other components.
## Use [member is_frozen], [signal froze] and [signal thawed] to determine outside behavior when component is frozen.


## Signal emitted once component has been frozen.
signal froze
## Signal emitted once component thas thawed.
signal thawed


## The target's [Sprite2D] or [AnimatedSprite2D].
## Sprite will be highlighted when interacting with [TargetingSystem].
@export var sprite: Node2D
## Node that handles the target's animation, if any.
## Currently supports [AnimatedSprite2D] and [AnimationPlayer].
## Built-in processing will be stopped once frozen.
@export var animator: Node
## Time it takes to before thawing out in seconds.
## During this time, [method _process] and [method _physics_process] callbacks will be stopped.
@export_range(0.0, 99.0, 0.1) var freeze_time: float

## Flag to determine if target is frozen or not.
var is_frozen: bool


## Freezes the animator's built-in processing.
##
## NOTE: Currently only stopping the [member animator] built-in processing.
## We still want the node containing this component to interact with the game world,
## especially if [InteractableObject] contains other components.
## Use [member is_frozen], [signal froze] and [signal thawed] to determine outside behavior when component is frozen.
func freeze() -> void:
	if is_frozen: return

	is_frozen = true
	froze.emit()
	Utils.ProcessUtils.toggle_processing(animator, false)
	
	await get_tree().create_timer(freeze_time).timeout
	
	is_frozen = false
	thawed.emit()
	Utils.ProcessUtils.toggle_processing(animator, true)
	
	# TODO: Add frozen shader effect.
