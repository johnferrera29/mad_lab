class_name ResizerDiscProjectile
extends Projectile
## A projectile that can be launched via the [ScaleGun].
##
## Resizes an [InteractableObject] that contains a [ScalableComponent] on collision.


var scale_mode: Enums.ScaleMode


func _on_body_entered(body: Node2D) -> void:
	var interactable_object := body as InteractableObject

	if interactable_object and interactable_object.scalable_component:
		interactable_object.scalable_component.scale(scale_mode)
		destroy()
	else:
		# TODO: Handle collision via collision layers to prevent colliding with [Player] and [ScaleGun]
		# For now, ignoring manually destroy if body is not [Player] or [ScaleGun].
		if not (body as Player) and not (body is ScaleGun):
			destroy()
