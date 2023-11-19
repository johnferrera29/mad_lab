extends Node
## Signal Bus autoload containing global signals.
##
## Commonly used to connect a deeply nested node to other nodes or updating the GUI.


# Player related signals.
signal player_died()
signal player_respawn_point_set(respawn_position: Vector2)
