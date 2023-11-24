class_name Switch
extends Node2D


@export var trigger_keys: Array[CollisionObject2D]
@export var one_shot: bool

@onready var _trigger := $TriggerArea as TriggerArea
@onready var _animated_sprite := $StaticBody2D/AnimatedSprite2D as AnimatedSprite2D


func _ready() -> void:
	_trigger.trigger_keys = trigger_keys
	_trigger.one_shot = one_shot


func _on_trigger_area_triggered() -> void:
	_animated_sprite.play("switch_on")


func _on_trigger_area_released() -> void:
	if not one_shot:
		_animated_sprite.play("switch_off")
