extends Node
## Dialog Manager
##
## @tutorial: https://www.youtube.com/watch?v=1DRy5An_6DU


## An array containing the lines the dialog manager will display.
var _dialog_lines: Array[String] = []
## Line index in [member _dialog_lines] being shown.
var _current_line_index: int
## Flag that determines whether there is an active dialog box being shown.
var _is_dialog_active: bool
## Flag to determine if the dialog box can be advanced by pressing a specific input.
## Ignored when using auto advance dialog.
var _can_advance_line: bool

## A reference to the active dialog box instance.
var _dialog_box: DialogBox
## A reference to the initial spawn position of the dialog box.
var _spawn_position: Vector2
## A reference to the optional dialog parameters used to customize dialog behavior.
var _dialog_params: StartDialogParams

## Determines auto advance behavior.
var _is_auto_advance: bool = true
## Default time it takes to advance to the next dialog box when using auto advance dialog.
var _auto_advance_time: float = 1.0

@onready var _dialog_box_resource = preload("res://scenes/gui/dialog_box/dialog_box.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") and _is_dialog_active and _can_advance_line and not _is_auto_advance:
		_show_next_dialog()


## Display the lines from [param dialog_lines] at a specified starting [param spawn_position].
## Use [DialogManager.StartDialogParams] to create optional parameters that customize dialog behavior.
func start_dialog(spawn_position: Vector2, dialog_lines: Array[String], dialog_params := StartDialogParams.new()) -> void:
	if _is_dialog_active:
		return
	
	_dialog_lines = dialog_lines
	_spawn_position = spawn_position
	_dialog_params = dialog_params
	
	_show_dialog_box()
	
	_is_dialog_active = true


## Helper function to clear and free all active dialog boxes that is a child of [DialogManager].
func clear_all_dialog() -> void:
	var children := get_children()
	
	if children.size() == 0: return
	
	for child in children:
		remove_child(child)
		child.queue_free()
	
	_dialog_box = null
	_current_line_index = 0
	_is_dialog_active = false


func _show_dialog_box() -> void:
	_dialog_box = _dialog_box_resource.instantiate() as DialogBox

	_dialog_box.finished.connect(_on_dialog_box_finished)

	_dialog_box.global_position = _spawn_position
	_dialog_box.horizontal_offset = _dialog_params.horizontal_offset
	_dialog_box.vertical_offset = _dialog_params.vertical_offset
	_dialog_box.audio_stream = _dialog_params.audio_stream
	
	add_child(_dialog_box)

	_dialog_box.display_text(_dialog_lines[_current_line_index])
	
	_can_advance_line = false

	# Check for auto advance behavior.
	if _is_auto_advance:
		await _dialog_box.finished

		var timing = _auto_advance_time
		if _dialog_params.auto_advance_time != timing:
			timing = _dialog_params.auto_advance_time
		
		await get_tree().create_timer(timing).timeout

		_show_next_dialog()


func _show_next_dialog() -> void:
	if not is_instance_valid(_dialog_box): return
	
	_dialog_box.queue_free()
	_dialog_box = null
	
	_current_line_index += 1

	# Check if the current line index is valid.
	if _current_line_index >= _dialog_lines.size():
		_is_dialog_active = false
		_current_line_index = 0
	else:
		_show_dialog_box()


func _on_dialog_box_finished() -> void:
	_can_advance_line = true


## An optional parameter class for customizing the behavior of dialog box when calling [method start_dialog].
class StartDialogParams:
	var horizontal_offset: float = 0.0
	var vertical_offset: float = 0.0
	var audio_stream: AudioStream
	var auto_advance_time: float = 1.0
