class_name TargetingSystem
extends RayCast2D
## A component that can detect and interact with an [InteractableObject].


## Signal emitted once target is detected.
signal target_detected(target: InteractableObject)
## Signal emitted once interaction with object initiated.
signal target_interacted(target: InteractableObject)
## Signal emitted once target is lost from view.
signal target_lost(target: InteractableObject)


## Makes the raycast line visible.
@export var visible_cast: bool

@onready var _line: Line2D = $Line2D

var _last_detected_target: Object


func _physics_process(delta: float) -> void:
	target_position = get_local_mouse_position()
	
	if visible_cast:
		_draw_raycast_line(global_position, get_global_mouse_position())
	
	if is_colliding():
		# Check if target extends InteractableObject.
		var target = get_collider() as InteractableObject
		if target:
			# Check if object same as last detected object.
			# This prevents target_detected signal from being emitted multiple times.
			if not _last_detected_target or target != _last_detected_target:
				# print("target detected")
				_last_detected_target = target
				target_detected.emit(target)
			
			if Input.is_action_just_pressed("interact"):
				# print("target interacted")
				target_interacted.emit(target)
	else:
		if _last_detected_target and is_instance_valid(_last_detected_target):
			# print("target lost")
			target_lost.emit(_last_detected_target)
			_last_detected_target = null
			


## Draws a visible line from [param start] to [param end].
func _draw_raycast_line(start: Vector2, end: Vector2) -> void:
	_line.points = PackedVector2Array([
		start,
		end
	])
