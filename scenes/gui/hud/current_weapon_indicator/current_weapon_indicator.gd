extends TextureRect


const WEAPON_SPRITES: Dictionary = {
	Enums.WeaponType.SCALE_GUN: preload("res://scenes/entities/weapons/scale_gun/resources/textures/weapon_scale_gun.png"),
	Enums.WeaponType.FREEZE_RAY: preload("res://scenes/entities/weapons/freeze_ray/resources/textures/weapon_freeze_ray.png"),
	Enums.WeaponType.BOMB_LAUNCHER: preload("res://scenes/entities/weapons/bomb_launcher/resources/textures/weapon_bomb_launcher.png"),
}


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.weapon_changed.connect(_on_weapon_changed)


func _on_weapon_changed(weapon_type: Enums.WeaponType) -> void:
	texture = WEAPON_SPRITES[weapon_type]
