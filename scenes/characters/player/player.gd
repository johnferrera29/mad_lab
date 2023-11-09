class_name Player
extends CharacterBody2D


@export_group("Movement")
@export var movement_speed: float = 300.0
@export var jump_force: float = 400.0
## Max [member CharacterBody2D.velocity.y] the player can achieve while falling.
@export var terminal_velocity: float = 500.0
## Gravity multiplier when player is falling.
## Only applied after jump force.
@export var gravity_multiplier: float = 1.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
