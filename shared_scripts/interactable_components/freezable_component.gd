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

## Target node to be frozen.
## Built-in processing will be stopped once frozen.
@export var target: Node2D
## A reference to the target's animator. 
## Will first attempt to find the [member target.animator] before using this one.
## Currently supports [AnimatedSprite2D] and [AnimationPlayer].
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

	var target_animator = _get_animator()

	is_frozen = true
	froze.emit()
	Utils.ProcessUtils.toggle_processing(target_animator, false)
	
	await get_tree().create_timer(freeze_time).timeout
	
	is_frozen = false
	thawed.emit()
	Utils.ProcessUtils.toggle_processing(target_animator, true)
	
	# TODO: Add frozen shader effect.


## Attempts to get the target's animator.
## Returns null if no animator is found.
func _get_animator() -> Node:
	# Try to get the target's animator variable.
	if target and target.animator:
		return target.animator
	# Try to find the animator in the target's child nodes.
	elif target and not target.animator:
		for child in target.get_children():
			var animated_sprite := child as AnimatedSprite2D
			if animated_sprite:
				return animated_sprite

			var animation_player := child as AnimationPlayer
			if animation_player:
				return animation_player
	# Try to get custom external animator specified in the export variable.
	elif animator:
		return animator
	
	return null
