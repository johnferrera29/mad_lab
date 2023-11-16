extends Node
## Autoload that contains a number of utility classes and methods.

## Animation utility class.
class AnimationUtils:
	## Awaitable coroutine to play animation.
	##
	## Useful for instances animation needs to finish playing before continuing.
	## Accepts [param animator] that will handle animations. Currently supports [AnimatedSprite2D] and [AnimationPlayer].
	## Accepts [param animation_name] is the name of the animation to be played.
	## 
	## Returns a bool whether animation was played or not.
	static func play_animation(animator, animation_name: String) -> bool:
		var animated_sprite = animator as AnimatedSprite2D
		if animated_sprite and animated_sprite.sprite_frames.has_animation(animation_name):
			animated_sprite.play(animation_name)
			await animated_sprite.animation_finished

			return true

		var animation_player = animator as AnimationPlayer
		if animation_player and animation_player.has_animation(animation_name):
			animation_player.play(animation_name)
			await animation_player.animation_finished

			return true
		
		return false
