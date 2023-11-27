extends Node
## Audio Manager singleton.
##
## Useful for playing one shot audio for dynamically created and freed objects.
## AudioStreamPlayers will use the SFX audio bus.


const SFX_BUS_NAME: String = "SFX"

func play_sound(stream: AudioStream, params: PlaySoundParams = PlaySoundParams.new()) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.bus = SFX_BUS_NAME

	audio_stream_player.stream = stream
	audio_stream_player.volume_db = params.volume_db
	audio_stream_player.pitch_scale = params.pitch_scale
	
	audio_stream_player.finished.connect(_on_audio_stream_player_finished.bind(audio_stream_player))

	add_child(audio_stream_player)

	audio_stream_player.play()


func _on_audio_stream_player_finished(audio_stream_player: AudioStreamPlayer) -> void:
	audio_stream_player.queue_free()


class PlaySoundParams:
	var volume_db: float = 0.0
	var pitch_scale: float = 1.0

