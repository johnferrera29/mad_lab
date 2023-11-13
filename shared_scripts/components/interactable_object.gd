class_name InteractableObject
extends Node
## Virtual base class that exposes different types of interactable components.
##
## Every interactable object that wants to be detected by [TargetingSystem] should inherit this class.

@export_group("Components")
@export var scalable_component: ScalableComponent
