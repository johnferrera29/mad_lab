extends Control


var menu_clicked_audio_resource := preload("res://shared_resources/audio/menu_item_clicked.ogg")

@onready var continue_button := $VBoxContainer/ContinueButton as Button
@onready var audio_queue := $MenuFocusAudioQueue as AudioQueue


func _ready() -> void:
	if LevelManager.current_level_id:
		continue_button.disabled = false


func _on_new_game_button_pressed() -> void:
	# Reset weapon unlock flags
	GameManager.player_unlockables.freeze_ray = false
	GameManager.player_unlockables.bomb_launcher = false
	
	# Start from Level 1
	AudioManager.play_sound(menu_clicked_audio_resource)
	SignalBus.level_selected.emit(1, self)


func _on_continue_button_pressed() -> void:
	# Restart last level played.
	AudioManager.play_sound(menu_clicked_audio_resource)
	SignalBus.level_selected.emit(LevelManager.current_level_id, self)


func _on_exit_button_pressed() -> void:
	AudioManager.play_sound(menu_clicked_audio_resource)
	get_tree().quit()


func _on_button_mouse_entered() -> void:
	audio_queue.play_sound()
