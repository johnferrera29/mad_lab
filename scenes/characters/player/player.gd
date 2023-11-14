class_name Player
extends CharacterBody2D


@export_group("Movement")
@export var movement_speed: float

@export_group("Jump")
## Max jump height the player will reach in pixels.
@export var jump_height: float
## Time the player should take to reach the jump height in sceonds
@export_range(0.0, 10.0, 0.1) var jump_time_to_peak: float
## Time the player should take to reach the ground in seconds.
@export_range(0.0, 10.0, 0.1) var jump_time_to_descent: float
## Coyote time in seconds.
## This allows the player to jump for brief amount of time even after leaving the floor.
@export_range(0.0, 1.0, 0.1) var coyote_time: float
## Jump buffering in seconds. This allows more leeway for player jump inputs.
@export_range(0.0, 1.0, 0.1) var jump_buffer: float
## Max [member CharacterBody2D.velocity.y] the player can achieve while falling.
@export var terminal_velocity: float

# Jump related variables.
# @tutorial: https://www.youtube.com/watch?v=IOe1aGY6hXA
@onready var jump_force: float = (jump_height * 2.0) / jump_time_to_peak
@onready var jump_gravity: float = (jump_height * 2.0) / (jump_time_to_peak ** 2)
@onready var fall_gravity: float = (jump_height * 2.0) / (jump_time_to_descent ** 2)

# Player states.
@onready var state_machine := $StateMachine as StateMachine
@onready var idle_state := $StateMachine/Idle as PlayerIdleState
@onready var run_state := $StateMachine/Run as PlayerRunState
@onready var air_state := $StateMachine/Air as PlayerAirState
@onready var grappling_state := $StateMachine/Grappling as PlayerGrapplingState


func _ready() -> void:
	_connect_state_transitions()


func _connect_state_transitions() -> void:
	# Save callables to variables for reuse.
	var change_to_idle_state: Callable = state_machine.change_state.bind(idle_state)
	var change_to_run_state: Callable = state_machine.change_state.bind(run_state)
	var change_to_jump_state: Callable = state_machine.change_state.bind(air_state, air_state.create_state_params(true))
	var change_to_fall_state: Callable = state_machine.change_state.bind(air_state)
	
	# Connect player idle transition states.
	idle_state.actor_fell.connect(change_to_fall_state)
	idle_state.actor_jumped.connect(change_to_jump_state)
	idle_state.actor_ran.connect(change_to_run_state)

	# Connect player run transition states.
	run_state.actor_idle.connect(change_to_idle_state)
	run_state.actor_fell.connect(change_to_fall_state)
	run_state.actor_jumped.connect(change_to_jump_state)
	
	# Connect player air transition states.
	air_state.actor_idle.connect(change_to_idle_state)
	air_state.actor_ran.connect(change_to_run_state)

	# Connect player grappling transition states.
	grappling_state.actor_fell.connect(change_to_fall_state)
