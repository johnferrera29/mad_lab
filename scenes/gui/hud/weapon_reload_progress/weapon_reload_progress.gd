extends TextureProgressBar


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.weapon_reloaded.connect(_on_weapon_reloaded)
	SignalBus.weapon_reload_progressed.connect(_on_weapon_reload_progressed)


func _on_weapon_reloaded() -> void:
	# TODO: Add some animation cues when fully reloaded
	pass


func _on_weapon_reload_progressed(progress: float) -> void:
	value = progress

	if value == max_value:
		
		SignalBus.weapon_reloaded.emit()
