extends Node
## Signal Bus autoload containing global signals.
##
## Commonly used to connect a deeply nested node to other nodes or updating the GUI.


# Player related signals.
signal player_died()
## Signal emitted once a new respawn point has been set.
## Accepts [param respawn_position] that determines where the player will respawn.
signal player_respawn_point_set(respawn_position: Vector2)


# Scene related signals.
## Signal emitted when transitioning between scenes.
## Use [SceneManager.SceneChangeParams] to create parameters.
signal scene_change_triggered(params: SceneManager.SceneChangeParams)


# Level related signals.
## Signal emitted once a level has been selected to be loaded.
## Optional [param scene_to_unload] when emitting from GUI such as level selection screens that needs additional cleanup.
signal level_selected(level_id: int, scene_to_unload: Node)
signal level_started(level_id: int)


# Weapon related signals
signal weapon_reloaded()
signal weapon_reload_progressed(progress: float)
signal weapon_changed(weapon_type: Enums.WeaponType, scroll_direction: int)
signal weapon_mode_changed(weapon_mode: String)
signal weapon_drawn(weapon_count: int)
signal weapon_withdrawn()
