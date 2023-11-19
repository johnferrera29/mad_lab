class_name Level
extends Node2D
## Base class for all levels.


@export var level_id: int
@export var next_level_id: int


func _ready() -> void:
	SignalBus.level_started.emit(self)
