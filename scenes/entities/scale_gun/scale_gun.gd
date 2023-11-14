class_name ScaleGun
extends Node2D
## A gun that can shrink or enlarge an object.
##
## Target object must extend an [InteractableObject] and contains a [ScalableComponent].


@export_group("Target Highlight")
## Outline when target is detected by [TargetingSystem]
@export var target_highlight_size: float = 1.0
@export var target_highlight_color: Color = Color.WHITE

enum ScaleMode {
	SHRINK,
	ENLARGE,
	RESET,
}

## The currently selected scale mode. Defaults to [enum ScaleMode.SHRINK]
var current_mode: ScaleMode = ScaleMode.SHRINK
## Custom [ShaderMaterial] that contains the 2D outline shader.
var outline_material: ShaderMaterial = preload("res://shared_resources/shaders/2D_outline_outer.tres")


func _ready() -> void:
	# Initialize shader material related parameters.
	outline_material.set_shader_parameter("line_thickness", target_highlight_size)
	outline_material.set_shader_parameter("line_color", target_highlight_color)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("change_weapon_mode"):
		var new_mode = toggle_scale_mode()
		change_scale_mode(new_mode)


## Shrinks target by [param factor]. Negative values will be ignored.
func shrink(target: Node2D, original_scale: Vector2, factor: float) -> void:
	if (factor < 0.0): return
	target.scale = original_scale / factor


## Enlarges target by [param factor]. Negative values will be ignored.
func enlarge(target: Node2D, original_scale: Vector2, factor: float) -> void:
	if (factor < 0.0): return
	target.scale = original_scale * factor


## Resets the scale to original.
func reset_scale(target: Node2D, original_scale: Vector2) -> void:
	target.scale = original_scale


## Change the gun's current scale mode.
func change_scale_mode(mode: ScaleMode) -> void:
	print(ScaleMode.keys()[mode])
	current_mode = mode
	## TODO: Change shader depending on scale.


## Toggle through all available modes without going past the last index.
## Returns a [enum ScaleMode]
func toggle_scale_mode() -> ScaleMode:
	var max_index: int = ScaleMode.keys().size()
	var index: int = current_mode
	index += 1
	
	if index >= max_index:
		index = 0
	
	return index as ScaleMode


func add_highlight(sprite: Node2D) -> void:
	sprite.material = outline_material


func remove_highlight(sprite: Node2D) -> void:
	sprite.material = null


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	var scalable_component := target.scalable_component
	if scalable_component:
		add_highlight(scalable_component.sprite)


func _on_targeting_system_target_interacted(target: InteractableObject) -> void:
	var scalable_component := target.scalable_component
	if scalable_component:
		match current_mode:
			ScaleMode.SHRINK:
				shrink(scalable_component.target, scalable_component.original_scale, scalable_component.shrink_factor)
			ScaleMode.ENLARGE:
				enlarge(scalable_component.target, scalable_component.original_scale, scalable_component.shrink_factor)
			ScaleMode.RESET:
				reset_scale(scalable_component.target, scalable_component.original_scale)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	var scalable_component := target.scalable_component
	if scalable_component:
		remove_highlight(scalable_component.sprite)
