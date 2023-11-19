extends Node2D
## Starting zone that spawns the [Player].


var _player_scene := preload("res://scenes/characters/player/player.tscn")

@onready var _spawn_point := $PlayerSpawnPoint as Marker2D
@onready var _trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	_spawn_player()
	_set_as_respawn_point()


func _spawn_player() -> void:
	var player := _player_scene.instantiate() as Player

	# TODO: Use a GameManager.player_state to initialize the player.
	# This includes initializing its list of available weapons, etc.
	player.global_position = _spawn_point.global_position

	get_parent().add_child.call_deferred(player)

	_trigger.trigger_key = player
	GameManager.player = player


func _set_as_respawn_point() -> void:
	SignalBus.player_respawn_point_set.emit(_spawn_point.global_position)


func _on_trigger_area_triggered() -> void:
	_set_as_respawn_point()