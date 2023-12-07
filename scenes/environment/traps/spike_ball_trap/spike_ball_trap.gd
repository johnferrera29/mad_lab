extends Node2D


@onready var _trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	_trigger.trigger_keys.append(GameManager.player)


func _on_trigger_area_triggered() -> void:
	SignalBus.player_died.emit()
