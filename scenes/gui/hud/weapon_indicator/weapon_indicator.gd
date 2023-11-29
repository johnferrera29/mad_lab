extends Control


const WEAPONS: Dictionary = {
	Enums.WeaponType.SCALE_GUN: {
		"sprite": preload("res://scenes/entities/weapons/scale_gun/resources/textures/weapon_scale_gun.png"),
		"label": "Scale Gun",
	},
	Enums.WeaponType.BOMB_LAUNCHER: {
		"sprite": preload("res://scenes/entities/weapons/bomb_launcher/resources/textures/weapon_bomb_launcher.png"),
		"label": "Bomb Launcher",
	},
	Enums.WeaponType.FREEZE_RAY: {
		"sprite": preload("res://scenes/entities/weapons/freeze_ray/resources/textures/weapon_freeze_ray.png"),
		"label": "Freeze Ray",
	},
}

@onready var animator := $AnimationPlayer as AnimationPlayer
@onready var weapon_sprite := $WeaponSprite as Sprite2D
@onready var weapon_label := $WeaponLabel as Label
@onready var weapon_mode_label := $WeaponModeLabel as Label
@onready var weapon_reload_progress := $WeaponReloadProgress as TextureProgressBar
@onready var weapon_changed_audio := $WeaponChangedAudio as AudioStreamPlayer # TODO: Move this to WeaponManager
@onready var weapon_mode_changed_audio := $WeaponModeChangedAudio as AudioStreamPlayer # TODO: Move this to WeaponManager


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.weapon_changed.connect(_on_weapon_changed)
	SignalBus.weapon_mode_changed.connect(_on_weapon_mode_changed)


func _on_weapon_changed(weapon_type: Enums.WeaponType) -> void:
	weapon_changed_audio.play()
	weapon_sprite.texture = WEAPONS[weapon_type].sprite
	weapon_label.text = WEAPONS[weapon_type].label
	weapon_reload_progress.value = weapon_reload_progress.max_value
	
	# TODO: Make check more generic. Probably add a mode flag or something similar to Weapon class if it has different modes.
	if weapon_type == Enums.WeaponType.SCALE_GUN:
		weapon_mode_label.show()
	else:
		weapon_mode_label.hide()
	
	animator.play("changed")


func _on_weapon_mode_changed(mode: String) -> void:
	weapon_mode_label.text = mode
	weapon_mode_changed_audio.play()
