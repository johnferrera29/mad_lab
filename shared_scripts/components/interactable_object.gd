class_name InteractableObject
extends CollisionObject2D
## Virtual base class that exposes different types of interactable components.
##
## Every interactable object that wants to be detected by [TargetingSystem] should inherit this class.


@export_group("Components")
@export var scalable_component: ScalableComponent
@export var anchor_component: AnchorComponent
@export var freezable_component: FreezableComponent
