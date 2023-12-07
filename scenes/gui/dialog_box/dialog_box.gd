class_name DialogBox
extends MarginContainer
## A box for displaying text.
##
## @tutorial: https://www.youtube.com/watch?v=1DRy5An_6DU


## Signal emitted once dialog box has finished displaying text.
signal finished

const MAX_WIDTH: float = 256

var horizontal_offset: float
var vertical_offset: float
var audio_stream: AudioStream

var _text_to_display: String = ""
var _letter_index: int = 0

# Time in seconds to display certain characters.
var _letter_time: float = 0.03
var _space_time: float = 0.06
var _punctuation_time: float = 0.2

var _default_horizontal_offset: float = 0.0
var _default_vertical_offset: float = 32.0
var _default_dialog_audio_resource := preload("res://scenes/gui/dialog_box/resources/audio/character_dialog.mp3") as AudioStream

@onready var label := $MarginContainer/Label as Label
@onready var timer := $LetterDisplayTimer as Timer
@onready var dialog_audio_player := $DialogAudio as AudioStreamPlayer


## Displays text in a dialog box.
func display_text(text_to_display: String) -> void:
	# Set the audio stream and play it.
	if audio_stream:
		dialog_audio_player.stream = audio_stream
	else:
		dialog_audio_player.stream = _default_dialog_audio_resource
	dialog_audio_player.play()
	
	# Set the text and resize dialog box as needed.
	_text_to_display = text_to_display
	label.text = text_to_display
	
	await label.resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		
		await label.resized
		
		custom_minimum_size.y = size.y
	
	# FIXME: Randomly throwing error that causes some lag and on rare occasions a crash.
	# Happens after script has returned from awaiting the control's resized signal.
	
	# Center dialog box position.
	global_position.x -= size.x / 2 + (horizontal_offset if horizontal_offset != 0 else _default_horizontal_offset)
	global_position.y -= size.y + (vertical_offset if vertical_offset != 0 else _default_vertical_offset)
	
	label.text = ""

	_display_letter()


func _display_letter() -> void:
	label.text += _text_to_display[_letter_index]
	
	_letter_index += 1
	
	# Check if letter index is valid.
	if _letter_index >= _text_to_display.length():
		dialog_audio_player.stop()
		finished.emit()
		return
	
	match _text_to_display[_letter_index]:
		".", ",", "!", "?":
			timer.start(_punctuation_time)
		" ":
			timer.start(_space_time)
		_:
			timer.start(_letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
