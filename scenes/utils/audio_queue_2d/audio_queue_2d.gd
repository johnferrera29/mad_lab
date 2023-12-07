class_name AudioQueue2D
extends Node2D
## A variation of [AudioQueue] but for [AudioStreamPlayer2D]


@export var instance_count: int = 1

var _next: int = 0
var _audio_stream_players: Array[AudioStreamPlayer2D] = []


func _ready() -> void:
	if get_child_count() == 0:
		push_warning("Audio Queue contains no child node of type AudioStreamPlayer2D.")
		return

	var audio_stream_player = get_child(0) as AudioStreamPlayer2D

	if audio_stream_player:
		_audio_stream_players.append(audio_stream_player)

		for i in (instance_count - 1):
			var instance_duplicate := audio_stream_player.duplicate() as AudioStreamPlayer2D

			add_child(instance_duplicate)
			_audio_stream_players.append(instance_duplicate)
	else:
		push_warning("Audio Queue contains a child node that is not of AudioStreamPlayer2D.")


func play_sound() -> void:
	var next_audio_player := _audio_stream_players[_next]
	if is_inside_tree() and not next_audio_player.playing:
		
		next_audio_player.play()
		_next += 1
		_next %= _audio_stream_players.size()


# TODO: Add configuration warnings
