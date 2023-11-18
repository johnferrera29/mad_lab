class_name BombProjectile
extends Projectile
## A projectile that can be launched via the [BombLauncher].
##
## Destroys an [InteractableObject] that contains a [BreakableComponent] on collision.


func _on_body_entered(body: Node2D) -> void:
	var interactable_object := body as InteractableObject

	if interactable_object and interactable_object.breakable_component:
		interactable_object.breakable_component.destroy()
		destroy()
	else:
		# TODO: Handle collision via collision layers to prevent colliding with [Player] and [BombLauncher]
		# For now, ignoring manually destroy if body is not [Player] or [BombLauncher].
		if not (body as Player) and not (body as BombLauncher):
			destroy()
