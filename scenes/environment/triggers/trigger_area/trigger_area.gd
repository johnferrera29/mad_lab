class_name TriggerArea
extends Area2D
## Trigger area that emits [signal triggered] whenever it comes into contact with [member trigger_keys].


## Signal emitted when the area comes into contact with the trigger key
signal triggered()

## A list of keys that can activate this trigger.
@export var trigger_keys: Array[CollisionObject2D]
## Setting this to [code]true[/code] will only allow this to be triggered once.
@export var one_shot: bool

## Flag to verify whether the trigger has already been activated.
var _is_triggered: bool


## Emits [signal triggered] invoking associated callbacks.
## Can be used to manually activate this trigger.
## Returns a boolean indicating whether the trigger was successful.
func trigger() -> bool:
	if one_shot and _is_triggered:
			return false
	
	print("triggered")
	triggered.emit()
	_is_triggered = true

	return true


func _on_body_entered(body: Node2D) -> void:
	if body is CollisionObject2D and trigger_keys.has(body):
		trigger()


func _on_body_exited(body: Node2D) -> void:
	if body is CollisionObject2D and not one_shot and trigger_keys.has(body):
		_is_triggered = false
