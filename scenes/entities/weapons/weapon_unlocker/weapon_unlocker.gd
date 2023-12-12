@tool
extends Node2D


@export var weapon_type: Enums.WeaponType
@export var sprite_texture: CompressedTexture2D

var unlock_weapon_audio_resrouce := preload("res://scenes/entities/weapons/weapon_unlocker/resources/audio/unlock_weapon.ogg")

@onready var sprite := $Sprite2D as Sprite2D
@onready var trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	sprite.texture = sprite_texture
	
	trigger.trigger_keys.append(GameManager.player)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		sprite.texture = sprite_texture


func _on_trigger_area_triggered() -> void:
	SignalBus.unlock_weapon.emit(weapon_type)
	AudioManager.play_sound(unlock_weapon_audio_resrouce)
	
	self.queue_free()
