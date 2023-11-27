extends Node


func play_sound(stream: AudioStream) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = stream
	audio_stream_player.finished.connect(_on_audio_stream_player_finished.bind(audio_stream_player))

	add_child(audio_stream_player)

	audio_stream_player.play()


func _on_audio_stream_player_finished(audio_stream_player: AudioStreamPlayer) -> void:
	audio_stream_player.queue_free()
