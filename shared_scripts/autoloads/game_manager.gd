extends Node
## Manages the game state.


## A reference to the player.
var player: Player
## Marks the position where the player will respawn.
var last_respawn_position: Vector2

## A reference to the World scene.
var world: Node2D

# Audio stream resources
var _player_died_audio_resource = preload("res://shared_resources/audio/died.ogg") as AudioStream


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.player_respawn_point_set.connect(_on_player_respawn_point_set)


func _respawn_player() -> void:
	player.show()
	Utils.ProcessUtils.toggle_processing(player.state_machine, true)
	
	player.velocity = Vector2.ZERO
	player.global_position = last_respawn_position
	player.state_machine.change_state(player.idle_state)


# Signal callbacks.
func _on_player_respawn_point_set(respawn_position: Vector2):
	print("Set player respawn point. ", respawn_position)
	last_respawn_position = respawn_position


func _on_player_died() -> void:
	print("Player died!")
	
	player.hide()
	Utils.ProcessUtils.toggle_processing(player.state_machine, false)
	
	var params := AudioManager.PlaySoundParams.new()
	params.pitch_scale = 0.5

	await AudioManager.play_sound(_player_died_audio_resource, params).finished
	
	_respawn_player()
