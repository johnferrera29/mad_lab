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
			destroy()
