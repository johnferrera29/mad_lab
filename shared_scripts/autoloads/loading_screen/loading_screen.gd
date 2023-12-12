extends CanvasLayer
## A screen that can be used to transition between different scenes.
##
## TODO: Implement actual background loading instead of faking loading progress.


@onready var _animator := $AnimationPlayer as AnimationPlayer


## Starts the screen transition
## Returns an awaitable [signal animation_finished].
func start_trasition(play_backwards: bool = false) -> Signal:
	if play_backwards:
		_animator.play_backwards("fade")
	else:
		_animator.play("fade")
	
	return _animator.animation_finished
