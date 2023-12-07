extends Control


@onready var _weapon_next := $WeaponNext as WeaponArrow
@onready var _weapon_prev := $WeaponPrevious as WeaponArrow
@onready var _arrow_cliked_audio := $ArrowClickedAudio as AudioStreamPlayer


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.weapon_drawn.connect(_on_weapon_drawn)
	SignalBus.weapon_scrolled.connect(_on_weapon_scrolled)


func _on_weapon_drawn(weapon_count: int) -> void:
	if weapon_count > 1:
		show()
	else:
		hide()


func _on_weapon_scrolled(scroll_direction: int) -> void:
	_arrow_cliked_audio.play()
	
	if scroll_direction == 1:
		_weapon_next.play_clicked_animation()
	else:
		_weapon_prev.play_clicked_animation()
