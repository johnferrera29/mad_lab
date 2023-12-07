extends Node2D
## Starting zone that spawns the [Player].
##
## Make sure to put this as the first node under the level scene.


## Reference to the current level.
@export var level: Level

var _player_resource := preload("res://scenes/characters/player/player.tscn")

@onready var _spawn_point := $PlayerSpawnPoint as Marker2D
@onready var _trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	_spawn_player()
	_set_as_respawn_point()


func _spawn_player() -> void:
	GameManager.player = _player_resource.instantiate() as Player
	GameManager.player.global_position = _spawn_point.global_position
	
	_trigger.trigger_keys.append(GameManager.player)

	level.add_child.call_deferred(GameManager.player)


func _set_as_respawn_point() -> void:
	SignalBus.player_respawn_point_set.emit(_spawn_point.global_position)


func _on_trigger_area_triggered() -> void:
	_set_as_respawn_point()
