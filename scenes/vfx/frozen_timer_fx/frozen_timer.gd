class_name FrozenTimer
extends Node2D


## Signal emitted once timer has stopped.
signal finished

## The amount of time in seconds before timer is finished.
var _elapsed_time: float

@onready var _label := $FrozenTimerLabel as Label
@onready var _timer := $Timer as Timer
@onready var _animator := $AnimationPlayer as AnimationPlayer


func start(duration: float) -> void:
	_elapsed_time = duration

	if _elapsed_time > 0.0:
		_update_label()
		_timer.start()


func _update_label() -> void:
	_label.text = str(_elapsed_time)
	_animator.play("tick")


func _on_timer_timeout() -> void:
	if _elapsed_time > 0:
		_elapsed_time -= _timer.wait_time
		_update_label()
	else:
		_timer.stop()
		finished.emit()
