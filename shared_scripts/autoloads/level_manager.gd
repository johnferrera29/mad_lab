extends Node
## Manages level selection and transition.


var current_level: Level


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.level_selected.connect(_on_level_selected)
	SignalBus.level_started.connect(_on_level_started)


## Loads a level based on [param level_id] defined in [member LEVEL_RESOURCES].
## Optional [param scene_to_unload] when emitting from GUI such as level selection screens.
func _proceed_to_level(level_id: int, scene_to_unload: Node = null) -> void:
	var params = SceneManager.SceneChangeParams.new()

	params.scene_to_load_path = LEVEL_RESOURCES[level_id]
	params.parent_scene = GameManager.world
	# TODO: Make scene_to_unload an array of scenes that needs to be cleaned up.
	params.scene_to_unload = current_level if not scene_to_unload else scene_to_unload

	SignalBus.scene_change_triggered.emit(params)


func _on_level_selected(level_id: int, scene_to_unload: Node = null) -> void:
	_proceed_to_level(level_id, scene_to_unload)


func _on_level_started(level: Level) -> void:
	current_level = level


## Contains a list of all level ids and its associated resource.
const LEVEL_RESOURCES = {
	1: "res://scenes/world/levels/level_01.tscn",
	2: "res://scenes/world/levels/level_02.tscn",
}
