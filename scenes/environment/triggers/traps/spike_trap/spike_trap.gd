@tool
extends Node2D


## The number of spikes to be spawned.
@export var spike_count: int = 1

@onready var _trigger := $TriggerArea as TriggerArea
@onready var _collision_shape := $TriggerArea/CollisionShape2D as CollisionShape2D
@onready var _sprite := $Sprite2D as Sprite2D

@onready var _sprite_region_size: float = _sprite.region_rect.size.x
@onready var _collision_shape_original_scale: float = _collision_shape.scale.x


func _ready() -> void:
	if not Engine.is_editor_hint():
		_trigger.trigger_keys.append(GameManager.player)

		_apply_spike_count()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_apply_spike_count()


func _apply_spike_count() -> void:
	_sprite.region_rect.size.x = _sprite_region_size * spike_count
	_trigger.scale.x = _collision_shape_original_scale * spike_count


func _on_trigger_area_triggered() -> void:
	if not Engine.is_editor_hint():
		SignalBus.player_died.emit()
