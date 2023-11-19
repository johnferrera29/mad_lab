class_name TrapArea
extends Area2D
## Trap area that emits a global [signal SignalBus.target_trapped] whenever it comes into contact with one of its [member targets].


## A list of targets that this area can trap.
@export var targets: Array[CollisionObject2D]


func _trap_target(target: CollisionObject2D) -> void:
	print("trapped: ", target)
	SignalBus.target_trapped.emit(target)


func _on_body_entered(body: CollisionObject2D) -> void:
	if targets.has(body):
		_trap_target(body)
