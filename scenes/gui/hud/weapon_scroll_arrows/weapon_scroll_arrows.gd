extends Control


@onready var weapon_next := $WeaponNext as WeaponArrow
@onready var weapon_prev := $WeaponPrevious as WeaponArrow
@onready var arrow_cliked_audio := $ArrowClickedAudio as AudioStreamPlayer


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.weapon_drawn.connect(_on_weapon_drawn)
	SignalBus.weapon_changed.connect(_on_weapon_changed)


func _on_weapon_drawn(weapon_count: int) -> void:
	if weapon_count > 1:
		show()
	else:
		hide()


func _on_weapon_changed(weapon_type: Enums.WeaponType, scroll_direction: int) -> void:
	arrow_cliked_audio.play()
	if scroll_direction == 1:
		weapon_next.play_clicked_animation()
	else:
		weapon_prev.play_clicked_animation()
