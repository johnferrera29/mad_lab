class_name ScaleGun
extends Node2D
## A gun that can shrink or enlarge an object.
##
## Target object must extend an [InteractableObject] and contains a [ScalableComponent].


enum ScaleMode {
	SHRINK,
	ENLARGE,
	RESET,
}

## The currently selected scale mode. Defaults to [enum ScaleMode.SHRINK]
var current_mode: ScaleMode = ScaleMode.SHRINK


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
	## TODO: Activate scale preview.


## Toggle through all available modes without going past the last index.
## Returns a [enum ScaleMode]
func toggle_scale_mode() -> ScaleMode:
	var max_index: int = ScaleMode.keys().size()
	var index: int = current_mode
	index += 1
	
	if index >= max_index:
		index = 0
	
	return index as ScaleMode


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	# TODO: Activate scale preview.
	pass # Replace with function body.


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


func _on_targeting_system_target_lost() -> void:
	# TODO: Deactivate scale preview.
	pass # Replace with function body.
