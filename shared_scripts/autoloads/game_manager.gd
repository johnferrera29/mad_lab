extends Node
## Manages the game state.


## A reference to the player.
var player: Player
## Marks the position where the player will respawn.
var last_respawn_position: Vector2


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.player_respawn_point_set.connect(_on_player_respawn_point_set)


func _respawn_player() -> void:
	player.velocity = Vector2.ZERO
	player.global_position = last_respawn_position
	player.state_machine.change_state(player.idle_state)


# Signal callbacks.
func _on_player_respawn_point_set(respawn_position: Vector2):
	print("Set player respawn point. ", respawn_position)
	last_respawn_position = respawn_position


func _on_player_died() -> void:
	print("Player died!")
	_respawn_player()
