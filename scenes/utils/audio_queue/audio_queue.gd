class_name AudioQueue
extends Node


@export var instance_count: int = 1

var _next: int = 0
var _audio_stream_players: Array[AudioStreamPlayer] = []


func _ready() -> void:
	if get_child_count() == 0:
		push_warning("Audio Queue contains no child node of type AudioStreamPlayer.")
		return

	var audio_stream_player := get_child(0) as AudioStreamPlayer

	if audio_stream_player:
		_audio_stream_players.append(audio_stream_player)

		for i in (instance_count - 1):
			var instance_duplicate := audio_stream_player.duplicate() as AudioStreamPlayer

			add_child(instance_duplicate)
			_audio_stream_players.append(instance_duplicate)
	else:
		push_warning("Audio Queue contains a child node that is not of AudioStreamPlayer.")


func play_sound() -> void:
	if not _audio_stream_players[_next].playing:
		_audio_stream_players[_next].play()
		_next += 1
		_next %= _audio_stream_players.size()


# TODO: Add configuration warnings
