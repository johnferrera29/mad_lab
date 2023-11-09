class_name State
extends Node
## Virtual base class for states used by StateMachine.
##
## Contains methods to be overriden by derived classes.


signal transitioned(state, new_state_name)


# Virtual function. Called by the state machine upon changing the active state. The `data` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func state_enter(msg := {}) -> void:
	pass


func state_exit() -> void:
	pass


func state_process(delta: float) -> void:
	pass


func state_physics_process(delta: float) -> void:
	pass


# TODO: Check if we can add a reference to StateMachine instead
# Can also use a dictionary or enum of valid states the player can take.
# This will prevent passing magic strings in new_state_name.
func transition_to(state: State, new_state_name: String, msg: Dictionary = {}):
	# print("state transitioned: ", state.name, " -> ", new_state_name)
	transitioned.emit(state, new_state_name, msg)
