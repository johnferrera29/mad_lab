class_name StateMachine
extends Node
## Generic state machine. Initializes states and delegates engine callbacks to the active state.


@export var initial_state: State
@export var initial_state_msg: Dictionary = {}

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)
		else:
			push_warning("State Machine contains a child that is not derived from virtual State class.")
	
	if initial_state:
		initial_state.state_enter(initial_state_msg)
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.state_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.state_physics_process(delta)


func _on_state_transitioned(state, new_state_name, msg) -> void:
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.state_exit()

	new_state.state_enter(msg)

	current_state = new_state
