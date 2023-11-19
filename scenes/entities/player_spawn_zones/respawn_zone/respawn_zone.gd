extends Node2D
## Respawn zone that sets the player to respawn position.


@onready var _respawn_point := $PlayerRespawnPoint as Marker2D
@onready var _trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	_trigger.trigger_key = GameManager.player


func _set_as_respawn_point() -> void:
	SignalBus.player_respawn_point_set.emit(_respawn_point.global_position)


func _on_trigger_area_triggered() -> void:
	_set_as_respawn_point()
