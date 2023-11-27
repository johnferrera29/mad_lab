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
@onready var weapon_reload_progress := $WeaponReloadProgress as TextureProgressBar


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.weapon_changed.connect(_on_weapon_changed)


func _on_weapon_changed(weapon_type: Enums.WeaponType, scroll_direction: int) -> void:
	weapon_sprite.texture = WEAPONS[weapon_type].sprite
	weapon_label.text = WEAPONS[weapon_type].label
	weapon_reload_progress.value = weapon_reload_progress.max_value
	
	animator.play("changed")
