extends Node
## Manages level selection and transition.


var current_level_id: int


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.level_selected.connect(_on_level_selected)
	SignalBus.level_started.connect(_on_level_started)


## Loads a level based on [param level_id] defined in [member LEVEL_RESOURCES].
## Optional [param scene_to_unload] when emitting from GUI such as level selection screens.
func _proceed_to_level(level_id: int, scene_to_unload: Node = null) -> void:
	await LoadingScreen.start_trasition()

	var params = SceneManager.SceneChangeParams.new()

	params.scene_to_load_path = LEVEL_RESOURCES[level_id]
	params.parent_scene = GameManager.world
	params.scenes_to_unload.append_array([
		get_tree().get_first_node_in_group(str("level", current_level_id)),
		scene_to_unload
	])
	
	SignalBus.scene_change_triggered.emit(params)

	await LoadingScreen.start_trasition(true)


func _on_level_selected(level_id: int, scene_to_unload: Node = null) -> void:
	_proceed_to_level(level_id, scene_to_unload)


func _on_level_started(level_id: int) -> void:
	current_level_id = level_id


## Contains a list of all level ids and its associated resource.
const LEVEL_RESOURCES = {
	1: "res://scenes/world/levels/stage_01/level_01.tscn",
	2: "res://scenes/world/levels/stage_01/level_02.tscn",
	3: "res://scenes/world/levels/stage_01/level_03.tscn",
	4: "res://scenes/world/levels/stage_01/level_04.tscn",
	5: "res://scenes/world/levels/stage_01/level_05.tscn",
	6: "res://scenes/world/levels/stage_01/level_06.tscn",
	7: "res://scenes/world/levels/stage_01/level_07.tscn",
	8: "res://scenes/world/levels/stage_01/level_08.tscn",
	9: "res://scenes/world/levels/stage_01/level_09.tscn",
	10: "res://scenes/world/levels/stage_01/level_10.tscn",
}

## For testing purposes
const LEVEL_RESOURCES_TEST = {
	1: "res://scenes/world/levels/test_levels/level_01.tscn",
	2: "res://scenes/world/levels/test_levels/level_02.tscn",
}
