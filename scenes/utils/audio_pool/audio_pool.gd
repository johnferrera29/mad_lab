class_name AudioPool
extends Node


var _audio_queues: Array[AudioQueue] = []
var _last_index: int = -1


func _ready() -> void:
	for child in get_children():
		var audio_queue := child as AudioQueue
		if audio_queue:
			_audio_queues.append(audio_queue)


func play_random_sound() -> void:
	var index := randi_range(0, _audio_queues.size() - 1)
	while index == _last_index:
		index = randi_range(0, _audio_queues.size() - 1)

	_last_index = index
	_audio_queues[index].play_sound()

	print("play RANDOM sound")


# TODO: Add configuration warnings
