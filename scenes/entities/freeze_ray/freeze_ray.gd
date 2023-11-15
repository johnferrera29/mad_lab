class_name FreezeRay
extends Node2D
## A gun that freezes specified target.
##
## "Freezing" in this case is stoping the target's built-in processes (e.g. _physics_process, _input, etc.) and any attached animators.
## Target object must extend an [InteractableObject] and contains a [FreezableComponent].


@export_group("Target Highlight")
## Outline when target is detected by [TargetingSystem]
@export var target_highlight_size: float = 1.0
@export var target_highlight_color: Color = Color.WHITE

## Custom [ShaderMaterial] that contains the 2D outline shader.
var outline_material: ShaderMaterial = preload("res://shared_resources/shaders/2D_outline_outer.tres")


func _ready() -> void:
	# Initialize shader material related parameters.
	outline_material.set_shader_parameter("line_thickness", target_highlight_size)
	outline_material.set_shader_parameter("line_color", target_highlight_color)


func add_highlight(sprite: Node2D) -> void:
	sprite.material = outline_material


func remove_highlight(sprite: Node2D) -> void:
	sprite.material = null


func freeze(freezable_component: FreezableComponent) -> void:
	print("freeze")
	freezable_component.is_frozen = true
	toggle_processing(freezable_component.target, false)
	toggle_animations(freezable_component.sprite as AnimatedSprite2D, freezable_component.animator, false)
	
	await get_tree().create_timer(freezable_component.freeze_time).timeout
	
	freezable_component.is_frozen = false
	toggle_processing(freezable_component.target, true)
	toggle_animations(freezable_component.sprite as AnimatedSprite2D, freezable_component.animator, true)
	
	# TODO: Add frozen shader effect


## Enables or disables built-in processing callbacks of [param target].
## This includes: [method _physics_process], [method _process], [method _input], [method _unhandled_input]
func toggle_processing(target: Node2D,  flag: bool) -> void:
	print("toggle_target_processing: ", flag)
	target.set_physics_process(flag)
	target.set_process(flag)
	target.set_process_input(flag)
	target.set_process_unhandled_input(flag)


## Toggles animations on or off._add_constant_torque
func toggle_animations(animated_sprite: AnimatedSprite2D, animator: AnimationPlayer, flag: bool) -> void:
	if animated_sprite:
		if flag:
			animated_sprite.pause()
		else:
			animated_sprite.play()
	
	if animator:
		if flag:
			animator.play()
		else:
			animator.pause()


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	var freezable_component := target.freezable_component
	if freezable_component:
		add_highlight(freezable_component.sprite)


func _on_targeting_system_target_interacted(target: InteractableObject) -> void:
	var freezable_component := target.freezable_component
	if freezable_component and not freezable_component.is_frozen:
		freeze(freezable_component)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	var freezable_component := target.freezable_component
	if freezable_component:
		remove_highlight(freezable_component.sprite)
