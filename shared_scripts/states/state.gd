class_name State
extends Node
## Virtual base class for states used by StateMachine.
##
## Contains methods to be overriden by derived classes.


## Virtual function. Receives events from the '_unhandled_input()' callback.
func state_handle_input(event: InputEvent) -> void:
	pass


## Virtual function. Called by the state machine upon changing the active state.
## The optional [param msg] is a dictionary with arbitrary data the state can use to initialize itself.
func state_enter(msg: Dictionary = {}) -> void:
	pass


## Virtual function. Called by the state machine upon changing the active state.
func state_exit() -> void:
	pass


## Virtual function. Corresponds to the '_process()' callback.
func state_process(delta: float) -> void:
	pass


## Virtual function. Corresponds to the '_physics_process()' callback.
func state_physics_process(delta: float) -> void:
	pass


# TODO: Try to create virtual function once varargs has been implmented in Godot.
# @reference: https://github.com/godotengine/godot/pull/82808
# func create_state_params(...args) -> Dictionary:
# 	return {}
