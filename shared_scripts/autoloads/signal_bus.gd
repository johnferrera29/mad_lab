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
