class_name FreezableComponent
extends Node
## A component that allows [member target] to be frozen by [IceBeamProjectile].
##
## Use this component with composition.
##
## NOTE: Currently only stopping the target's animators built-in processing.
## We still want the node containing this component to interact with the game world,
## especially if [InteractableObject] contains other components.
## Use [member is_frozen], [signal froze] and [signal thawed] to determine outside behavior when component is frozen.


## Signal emitted once component has been frozen.
signal froze
## Signal emitted once component thas thawed.
signal thawed

## Target node to be frozen.
## Built-in processing of animators inside the target will be stopped once frozen.
@export var target: Node2D
## A reference to the target's external animator.
@export var animator: AnimationPlayer
## Time it takes to before thawing out in seconds.
## During this time, [method _process] and [method _physics_process] callbacks will be stopped.
@export_range(0.0, 99.0, 0.1) var freeze_time: float = 1.0

## Flag to determine if target is frozen or not.
var is_frozen: bool

var _frozen_fx_resource := preload("res://scenes/vfx/frozen_fx/frozen_fx.tscn")
var _frozen_timer_resource := preload("res://scenes/vfx/frozen_timer_fx/frozen_timer.tscn")
var _frozen_audio_resource := preload("res://shared_resources/audio/frozen.wav")

var _frozen_fx: GPUParticles2D
var _frozen_timer: FrozenTimer
var _frozen_audio: AudioStreamPlayer2D


func _ready() -> void:
	_add_frozen_fx()
	_add_frozen_timer()
	_add_frozen_audio()
	_init_connections()


## Freezes the animator's built-in processing.
##
## NOTE: Currently only stopping the target's animators built-in processing.
## We still want the node containing this component to interact with the game world,
## especially if [InteractableObject] contains other components.
## Use [member is_frozen], [signal froze] and [signal thawed] to determine outside behavior when component is frozen.
func freeze() -> void:
	if is_frozen: return

	is_frozen = true
	froze.emit()

	_frozen_timer.start(freeze_time)
	_frozen_audio.play()
	_frozen_timer.show()
	_frozen_fx.emitting = true

	var target_animators := _get_animators()
	for node in target_animators:
		Utils.ProcessUtils.toggle_processing(node, false)


## Thaws the frozen object.
func thaw() -> void:
	if not is_frozen: return
	
	is_frozen = false
	thawed.emit()
	
	_frozen_audio.stop()
	_frozen_timer.hide()
	_frozen_fx.emitting = false

	var target_animators := _get_animators()
	for node in target_animators:
		Utils.ProcessUtils.toggle_processing(node, true)


## Initializes dynamic signal connections.
func _init_connections() -> void:
	if target and target.scalable_component:
		target.scalable_component.scaled.connect(_on_scaled)


## Attempts to get the target's animators.
func _get_animators() -> Array[Node]:
	var animators: Array[Node] = []
	
	# Try to get the target's animator variable.
	if target and target.animator:
		animators.append(target.animator)
	# Try to find the animator in the target's child nodes.
	elif target and not target.animator:
		for child in target.get_children():
			var animated_sprite := child as AnimatedSprite2D
			if animated_sprite:
				animators.append(animated_sprite)
	
			var animation_player := child as AnimationPlayer
			if animation_player:
				animators.append(animation_player)
	
	# Try to get custom external animator specified in the export variable.
	if animator:
		animators.append(animator)
	
	return animators


## Adds a frozen fx particle to the target.
func _add_frozen_fx() -> void:
	_frozen_fx = _frozen_fx_resource.instantiate() as GPUParticles2D
	_frozen_fx.emitting = false

	target.add_child.call_deferred(_frozen_fx)


## Adds a frozen timer countdown to the target.
func _add_frozen_timer() -> void:
	_frozen_timer = _frozen_timer_resource.instantiate() as FrozenTimer
	_frozen_timer.finished.connect(thaw)
	_frozen_timer.hide()

	target.add_child.call_deferred(_frozen_timer)


## Adds freezing audio to the target.
func _add_frozen_audio() -> void:
	_frozen_audio = AudioStreamPlayer2D.new()
	_frozen_audio.stream = _frozen_audio_resource
	_frozen_audio.volume_db = 5.0
	_frozen_audio.pitch_scale = 0.8
	_frozen_audio.max_distance = 500.0

	target.add_child.call_deferred(_frozen_audio) 


func _on_scaled(new_scale: Vector2) -> void:
	_frozen_fx.scale = new_scale
	_frozen_timer.scale = new_scale
