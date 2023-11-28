extends CanvasLayer

@onready var animator := $AnimationPlayer as AnimationPlayer


## Awaitable transition screen.
func start_trasition(play_backwards: bool = false) -> void:
	if play_backwards:
		animator.play_backwards("fade")
	else:
		animator.play("fade")
	
	await animator.animation_finished
