extends Control


@onready var weapon_hud := $WeaponHUD as Control


func _ready() -> void:
	_init_connections()
	weapon_hud.hide()


func _init_connections() -> void:
	SignalBus.weapon_drawn.connect(_on_weapon_drawn)
	SignalBus.weapon_withdrawn.connect(_on_weapon_withdrawn)


func _on_weapon_drawn(weapon_count: int) -> void:
	weapon_hud.show()


func _on_weapon_withdrawn() -> void:
	weapon_hud.hide()
