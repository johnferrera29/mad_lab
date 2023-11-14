class_name GrapplingHook
extends Node2D
## A grappling hook that launches the actor to a specified target.
##
## Target object must extend an [InteractableObject] and contains a [AnchorComopnent].


@export var actor: Player
@export var grappling_launch_force: float
@export var grappling_speed: float

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


## Launches the actor towards the direction of [param anchor].
## This will trigger a state change inside actor.
func launch_grappling_hook(anchor: Node2D, launch_force: float, speed: float) -> void:
	print("LAUNCH Grappling Hook")
	var state := actor.grappling_state
	var msg := state.create_state_params(anchor, launch_force, speed)

	actor.state_machine.change_state(state, msg)


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	var anchor_component := target.anchor_component
	if anchor_component:
		add_highlight(anchor_component.sprite)


func _on_targeting_system_target_interacted(target: InteractableObject) -> void:
	var anchor_component := target.anchor_component
	if anchor_component:
		launch_grappling_hook(anchor_component.target, grappling_launch_force, grappling_speed)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	var anchor_component := target.anchor_component
	if anchor_component:
		remove_highlight(anchor_component.sprite)
