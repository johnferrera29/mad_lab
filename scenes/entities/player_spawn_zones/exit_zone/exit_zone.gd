extends Node2D
## Exit zone that triggers the next level.


## The current level.
@export var current_level: Node2D
@export var next_level_scene: PackedScene


@onready var _trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	_trigger.trigger_keys.append(GameManager.player)


func _on_trigger_area_triggered() -> void:
	# TODO: LevelManager to change scenes.
	print("Exit zone!")
	var params = SceneManager.SceneChangeParams.new()

	params.scene_to_load = next_level_scene
	params.parent_scene = GameManager.world
	params.scene_to_unload = current_level

	SignalBus.scene_change_triggered.emit(params)
