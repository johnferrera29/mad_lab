class_name TargetingSystem
extends RayCast2D
## A component that can detect and interact with an [InteractableObject].


## Signal emitted once target is detected.
signal target_detected(target: InteractableObject)
## Signal emitted once target is lost from view.
signal target_lost(target: InteractableObject)

@export_group("Raycast Line")
## Makes the raycast line visible.
@export var visible_raycast_line: bool
## Texture to be applied to the visible line. By default no texture is applied.
@export var line_texture: Texture2D
## The starting point where the line will be drawn.
@export var line_starting_point: Marker2D
## The length of the raycast and drawn line.
## If not provided, will draw a line from [member line_starting_point] to mouse position.
@export var line_length: float
## The width of the visible line.
@export var line_width: float

@export_group("Shader Highlight")
## Custom [ShaderMaterial] that is applied to a specific sprite via [method toggle_shader_effect].
@export var shader_material: ShaderMaterial
## Used to customize the [member shader_material] effect and behavior.
## Refer to the [ShaderMaterial] resource for available parameters.
@export var shader_parameters: Dictionary

## The angle from the targeting system to the global mouse position in radians.
var target_angle: float
## The last detected target object.
var last_detected_target: Object

@onready var _line: Line2D = $Line2D


func _ready() -> void:
	_init_line()
	_init_shader_params()


func _physics_process(delta: float) -> void:
	var local_mouse_position := get_local_mouse_position()
	var global_mouse_position := get_global_mouse_position()

	# Create the raycast line.
	if visible_raycast_line:
		var starting_position = global_position if not line_starting_point else line_starting_point.global_position
		_draw_raycast_line(starting_position, global_mouse_position)

		if line_length:
			target_position = _caculate_end_position(position, local_mouse_position, line_length)
		else:
			target_position = local_mouse_position
	else:
		target_position = local_mouse_position
	
	# Set the target angle
	target_angle = global_position.angle_to_point(global_mouse_position)

	if is_colliding():
		# TODO: Redraw raycast if colliding with another object.

		# Check if target extends InteractableObject.
		var target = get_collider() as InteractableObject
		if target:
			# Check if object same as last detected object.
			# This prevents [signal target_detected] from being emitted multiple times.
			if not last_detected_target or target != last_detected_target:
				last_detected_target = target
				target_detected.emit(target)
	else:
		if last_detected_target and is_instance_valid(last_detected_target):
			target_lost.emit(last_detected_target)
			last_detected_target = null


## Toggles shader effect on or off. Replaces the sprite's [member CanvasItem.material].
func toggle_shader_effect(sprite: CanvasItem, flag: bool) -> void:
	sprite.material = shader_material if flag else null


func _init_line() -> void:
	_line.width = line_width

	if line_texture:
		_line.texture = line_texture
		_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		_line.texture_mode = Line2D.LINE_TEXTURE_TILE


func _init_shader_params() -> void:
	for key in shader_parameters:
		shader_material.set_shader_parameter(key, shader_parameters[key])


## Calculate the adjusted end position based on [param length].
## Useful if we want to limit the length of the raycast or when drawing the line.
func _caculate_end_position(start: Vector2, end: Vector2, length: float) -> Vector2:
		var direction := start.direction_to(end)
		var end_point :=  start + (direction * length)

		return end_point


## Draws a visible line from [param start] to [param end].
func _draw_raycast_line(start: Vector2, end: Vector2) -> void:
	var adjusted_end = end if not line_length else _caculate_end_position(start, end, line_length)

	_line.points = PackedVector2Array([
		start,
		adjusted_end
	])
