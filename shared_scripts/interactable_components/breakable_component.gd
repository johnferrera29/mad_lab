class_name BreakableComponent
extends Node
## A component that allows [member target] to be destroyed by [BombProjectile].
##
## Use this component with composition.


## Determines how fast the explosion animation happens in seconds.
const _EXPLOSION_TIME := 0.2

## Target node that will be destroyed. In most cases you want to destroy the scene's root or parent node.
@export var target: Node2D
## Optional reference to the target node's [InteractableObject].
## In most cases the [member target] and [member interactable_object] are the same.
## However, in instances where the [InteractableObject] is a child of [member target], we need to explicitly specify this one.
## If not set and [member target] is not empty, will reference the [member target].
@export var interactable_object: InteractableObject

## Flag to temporarily prevent the target object from being destroyed by a [BombProjectile].
var is_unbreakable: bool

var _explode_material := preload("res://shared_resources/shaders/explode.tres") as ShaderMaterial


func _ready() -> void:
	# Assign target to interactable_object only if interactable_object not set.
	if target and not interactable_object:
		interactable_object = target as InteractableObject


## Destroys the [member target].
func destroy() -> void:
	if not is_unbreakable:
		
		interactable_object.sprite.material = _explode_material

		# Animate explosion
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(interactable_object.sprite, "scale", interactable_object.sprite.scale * 2, _EXPLOSION_TIME)
		tween.tween_method(_update_explosion_dissolve, 1.0, 0.0, _EXPLOSION_TIME)
		
		await tween.finished

		target.queue_free()


func _update_explosion_dissolve(step: float) -> void:
	interactable_object.sprite.material.set_shader_parameter("dissolve_state", step)
