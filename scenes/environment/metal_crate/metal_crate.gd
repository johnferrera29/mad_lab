class_name MetalCrate
extends InteractableObject
## A metal crate that cannot be detroyed by a [BombProjectile] except when frozen.


func _ready() -> void:
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D

	if freezable_component:
		freezable_component.froze.connect(_on_froze)
		freezable_component.thawed.connect(_on_thawed)
	
	if breakable_component:
		breakable_component.is_unbreakable = true


func _on_froze() -> void:
	if breakable_component:
		breakable_component.is_unbreakable = false


func _on_thawed() -> void:
	if breakable_component:
		breakable_component.is_unbreakable = true
