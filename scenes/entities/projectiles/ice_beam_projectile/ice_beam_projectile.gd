class_name IceBeamProjectile
extends Projectile
## An ice beam that freezes everything it touches. Fired via the [FreezeRay].
##
## Freezes an [InteractableObject] that contains a [FreezableComponent] on collision.


func _on_body_entered(body: Node2D) -> void:
	var interactable_object := body as InteractableObject

	if interactable_object and interactable_object.freezable_component:
		interactable_object.freezable_component.freeze()
		destroy()
	else:
		destroy()
