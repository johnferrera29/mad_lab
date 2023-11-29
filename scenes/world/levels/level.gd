class_name Level
extends Node2D
## Base class for all levels.


@export var level_id: int
@export var next_level_id: int


func _ready() -> void:
	# Add unique level id as group name
	add_to_group(str("level", level_id))
	
	SignalBus.level_started.emit(level_id)
	
	_load_hud()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("back_to_menu"):
		_back_to_menu()


func _back_to_menu() -> void:
	var params = SceneManager.SceneChangeParams.new()
	params.scene_to_load_path = "res://scenes/gui/main_menu/main_menu.tscn"
	params.parent_scene = get_tree().get_first_node_in_group("gui")
	params.scenes_to_unload.append_array([
		self,
		get_tree().get_first_node_in_group("hud")
	])
	
	SignalBus.scene_change_triggered.emit(params)


func _load_hud() -> void:
	var params = SceneManager.SceneChangeParams.new()
	params.scene_to_load_path = "res://scenes/gui/hud/hud.tscn"
	params.parent_scene = get_tree().get_first_node_in_group("gui")
	params.scenes_to_unload.append_array([
		get_tree().get_first_node_in_group("hud")
	])

	SignalBus.scene_change_triggered.emit(params)
