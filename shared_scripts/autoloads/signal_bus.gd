extends Node
## Signal Bus autoload containing global signals.
##
## Commonly used to connect a deeply nested node to other nodes or updating the GUI.


## Signal emitted once a target comes into contact with a trap.
signal target_trapped(target: CollisionObject2D) 
