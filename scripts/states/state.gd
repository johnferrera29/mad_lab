class_name State
extends Node
## Virtual base class for states used by StateMachine.
##
## Contains methods to be overriden by derived classes.


signal transitioned(state, new_state_name)


func state_enter() -> void:
	pass


func state_exit() -> void:
	pass


func state_process(delta: float) -> void:
	pass


func state_physics_process(delta: float) -> void:
	pass
	