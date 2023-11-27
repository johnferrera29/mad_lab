class_name DialogBox
extends MarginContainer
## A box for displaying text.
##
## @tutorial: https://www.youtube.com/watch?v=1DRy5An_6DU


## Signal emitted once dialog box has finished displaying text.
signal finished

const MAX_WIDTH: float = 256

var text: String = ""
var letter_index: int = 0

var letter_time: float = 0.03
var space_time: float = 0.06
var punctuation_time: float = 0.2

var horizontal_offset: float
var vertical_offset: float

var _default_horizontal_offset: float = 0.0
var _default_vertical_offset: float = 25.0

@onready var label := $MarginContainer/Label as Label
@onready var timer := $LetterDisplayTimer as Timer


func display_text(text_to_display: String) -> void:
	text = text_to_display
	label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		
		await resized # wait for x resize
		await resized # wait for y resize
		
		custom_minimum_size.y = size.y
	
	# Center position
	global_position.x -= size.x / 2 + (horizontal_offset if horizontal_offset != 0 else _default_horizontal_offset)
	global_position.y -= size.y + (vertical_offset if vertical_offset != 0 else _default_vertical_offset)
	
	label.text = ""

	_display_letter()


func _display_letter() -> void:
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished.emit()
		return
	
	match text[letter_index]:
		".", ",", "!", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
