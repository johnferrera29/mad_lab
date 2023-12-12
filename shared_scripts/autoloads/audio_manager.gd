extends Node
## Audio Manager singleton.
##
## Useful for playing one shot audio for dynamically created and freed objects.
## AudioStreamPlayers will use the SFX audio bus.


const _SFX_BUS_NAME: String = "SFX"


## Plays a one shot sound.
## Use [param params] to customize behavior of [AudioStreamPlayer].
## Returns the [signal finished] of the [AudioStreamPlayer].
func play_sound(stream: AudioStream, params: PlaySoundParams = PlaySoundParams.new()) -> Signal:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.bus = _SFX_BUS_NAME

	audio_stream_player.stream = stream
	audio_stream_player.volume_db = params.volume_db
	audio_stream_player.pitch_scale = params.pitch_scale
	
	audio_stream_player.finished.connect(_on_audio_stream_player_finished.bind(audio_stream_player))

	add_child(audio_stream_player)

	audio_stream_player.play()

	return audio_stream_player.finished


func _on_audio_stream_player_finished(audio_stream_player: AudioStreamPlayer) -> void:
	audio_stream_player.queue_free()


## An optional parameter class for customizing the behavior of the [AudioStreamPlayer] when [method play_sound] is called.
class PlaySoundParams:
	var volume_db: float = 0.0
	var pitch_scale: float = 1.0
