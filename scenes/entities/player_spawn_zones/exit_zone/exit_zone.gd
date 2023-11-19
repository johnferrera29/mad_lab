extends Node2D
## Exit zone that enables proceeding to the next level.


## Reference to the current level.
@export var level: Level

@onready var _trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	_trigger.trigger_keys.append(GameManager.player)


func _on_trigger_area_triggered() -> void:
	print("Exit zone!")
	SignalBus.level_selected.emit(level.next_level_id)
