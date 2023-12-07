extends Node
## Manages scene loading and unloading.


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.scene_change_triggered.connect(_on_scene_change_triggered)


# Deleting the current scene at this point is a bad idea, because it may still be executing code.
# This will result in a crash or unexpected behavior.
# The solution is to defer the load to a later time, when we can be sure that no code from the current scene is running.
func _change_scene_deferred(params: SceneChangeParams) -> void:
	if not params: return

	# Unload all the scenes that needs to be unloaded.
	for scene_to_unload in params.scenes_to_unload:
		if scene_to_unload and not scene_to_unload.is_queued_for_deletion():
			scene_to_unload.free()
	
	var new_scene
	if params.scene_to_load:
		new_scene = params.scene_to_load.instantiate()
	elif params.scene_to_load_path:
		var scene_resource: Resource = ResourceLoader.load(params.scene_to_load_path)
		new_scene = scene_resource.instantiate()
	
	_call_auxiliary_methods()

	params.parent_scene.add_child(new_scene)


## Calls any additional methods used for cleanup or other essential tasks before loading a new scene.
func _call_auxiliary_methods() -> void:
	DialogManager.clear_all_dialog()


func _on_scene_change_triggered(params: SceneChangeParams) -> void:
	if params.delay:
		await get_tree().create_timer(params.delay).timeout
	
	call_deferred("_change_scene_deferred", params)


## Class to construct the scene change parameters when emitting [signal SignalBus.scene_change_triggered].
class SceneChangeParams:
	## The packed scene resource to be loaded.
	var scene_to_load: PackedScene
	
	## The scene resource path to be loaded.
	## Ignored if [member scene_to_load] already provided.
	var scene_to_load_path: String

	## Parent node where we want to attach the scene.
	var parent_scene: Node

	## Optional array of scenes to be unloaded.
	## Usually best practice to pass the scene in cases we want to replace it (e.g. changing levels).
	var scenes_to_unload: Array[Node] = []

	## Delay in seconds before loading the new scene.
	var delay: float
