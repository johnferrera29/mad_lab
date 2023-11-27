extends Node
## Dialog Manager
##
## @tutorial: https://www.youtube.com/watch?v=1DRy5An_6DU


var dialog_lines: Array[String] = []
var current_line_index: int

var dialog_box: DialogBox
var dialog_box_position: Vector2

var is_dialog_active: bool
var can_advance_line: bool

var is_auto_advance: bool = true
var auto_advance_time: float = 1.0

var _horizontal_offset: float
var _vertical_offset: float

@onready var dialog_box_resource = preload("res://scenes/gui/dialog_box/dialog_box.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") and is_dialog_active and can_advance_line and not is_auto_advance:
		_show_next_dialog()


func start_dialog(position: Vector2, lines: Array[String], horizontal_offset: float = 0.0, vertical_offset: float = 0.0) -> void:
	if is_dialog_active:
		return
	
	dialog_box_position = position
	dialog_lines = lines
	_horizontal_offset = horizontal_offset
	_vertical_offset = vertical_offset
	
	_show_dialog_box()
	
	is_dialog_active = true


func _show_dialog_box() -> void:
	dialog_box = dialog_box_resource.instantiate() as DialogBox
	
	GameManager.world.add_child(dialog_box)

	dialog_box.finished.connect(_on_dialog_box_finished)

	dialog_box.horizontal_offset = _horizontal_offset
	dialog_box.vertical_offset = _vertical_offset
	dialog_box.global_position = dialog_box_position

	dialog_box.display_text(dialog_lines[current_line_index])
	
	can_advance_line = false

	# Auto advance dialog box if flag is true
	if is_auto_advance:
		await dialog_box.finished
		await get_tree().create_timer(auto_advance_time).timeout

		_show_next_dialog()


func _show_next_dialog() -> void:
	dialog_box.queue_free()
		
	current_line_index += 1
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		return
	
	_show_dialog_box()


func _on_dialog_box_finished() -> void:
	can_advance_line = true
