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
## If provided, texture is repeated.
@export var line_texture: Texture2D
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

var _last_detected_target: Object

@onready var _line: Line2D = $Line2D


func _ready() -> void:
	_init_line()
	_init_shader_params()


func _physics_process(delta: float) -> void:
	target_position = get_local_mouse_position()
	var target_global_position := get_global_mouse_position()
	
	target_angle = global_position.angle_to_point(target_global_position)
	
	if visible_raycast_line:
		_draw_raycast_line(global_position, target_global_position)
	
	if is_colliding():
		# Check if target extends InteractableObject.
		var target = get_collider() as InteractableObject
		if target:
			# Check if object same as last detected object.
			# This prevents [signal target_detected] from being emitted multiple times.
			if not _last_detected_target or target != _last_detected_target:
				_last_detected_target = target
				target_detected.emit(target)
	else:
		if _last_detected_target and is_instance_valid(_last_detected_target):
			target_lost.emit(_last_detected_target)
			_last_detected_target = null


## Toggles shader effect on or off. Replaces the sprite's [member CanvasItem.material].
func toggle_shader_effect(sprite: CanvasItem, flag: bool) -> void:
	sprite.material = shader_material if flag else null


func _init_line() -> void:
	_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	_line.texture = line_texture
	_line.width = line_width


func _init_shader_params() -> void:
	for key in shader_parameters:
		shader_material.set_shader_parameter(key, shader_parameters[key])


## Draws a visible line from [param start] to [param end].
func _draw_raycast_line(start: Vector2, end: Vector2) -> void:
	_line.points = PackedVector2Array([
		start,
		end
	])
