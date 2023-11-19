class_name TriggerArea
extends Area2D
## Trigger area that emits [signal triggered] whenever it comes into contact with a specified [member trigger_key].


## Signal emitted when the area comes into contact with the trigger key
signal triggered()

## A collision object that serves as the key activate trigger.
@export var trigger_key: CollisionObject2D
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
	if body == trigger_key:
		trigger()


func _on_body_exited(body: Node2D) -> void:
	if not one_shot and body == trigger_key:
		_is_triggered = false