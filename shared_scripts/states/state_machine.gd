class_name StateMachine
extends Node
## Generic state machine. Initializes states and delegates engine callbacks to currently active state.


@export var initial_state: State
@export var initial_state_msg: Dictionary = {}

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
		else:
			push_warning("State Machine contains a child node that is not derived from virtual State class.")
	
	change_state(initial_state, initial_state_msg)


func _input(event: InputEvent) -> void:
	if current_state:
		current_state.state_handle_input(event)


func _process(delta: float) -> void:
	if current_state:
		current_state.state_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.state_physics_process(delta)


## Use to transition to another state.
## The optional [param msg] is a dictionary with arbitrary data the state can use to initialize itself.
func change_state(new_state: State, msg: Dictionary = {}) -> void:
	# _print_state_change(current_state, new_state)

	if current_state:
		current_state.state_exit()
	
	current_state = new_state
	current_state.state_enter(msg)


## For DEBUG purposes only. Prints the name of the previous state and new state.
func _print_state_change(previous_state: State, new_state: State) -> void:
	var previous_state_name = previous_state.name.to_lower() if previous_state != null else "null"
	var new_state_name = new_state.name.to_lower()

	print("State Changed: ", previous_state_name, " -> ", new_state_name)
