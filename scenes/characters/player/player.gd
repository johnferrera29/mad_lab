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

@onready var state_machine: StateMachine = $StateMachine as StateMachine
@onready var player_idle_state: PlayerIdleState = $StateMachine/Idle as PlayerIdleState
@onready var player_run_state: PlayerRunState = $StateMachine/Run as PlayerRunState
@onready var player_air_state: PlayerAirState = $StateMachine/Air as PlayerAirState

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	_connect_state_transitions()


func _connect_state_transitions() -> void:
	# Save callables to variables for reuse.
	var change_to_idle_state: Callable = state_machine.change_state.bind(player_idle_state)
	var change_to_run_state: Callable = state_machine.change_state.bind(player_run_state)
	var change_to_jump_state: Callable = state_machine.change_state.bind(player_air_state, { jump = true })
	var change_to_fall_state: Callable = state_machine.change_state.bind(player_air_state)
	
	# Connect player idle transition states.
	player_idle_state.actor_fell.connect(change_to_fall_state)
	player_idle_state.actor_jumped.connect(change_to_jump_state)
	player_idle_state.actor_ran.connect(change_to_run_state)

	# Connect player run transition states.
	player_run_state.actor_idle.connect(change_to_idle_state)
	player_run_state.actor_fell.connect(change_to_fall_state)
	player_run_state.actor_jumped.connect(change_to_jump_state)
	
	# Connect player air transition states.
	player_air_state.actor_idle.connect(change_to_idle_state)
	player_air_state.actor_ran.connect(change_to_run_state)
