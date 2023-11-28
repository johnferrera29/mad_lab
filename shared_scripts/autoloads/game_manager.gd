extends Node
## Manages the game state.
## 
## TODO: Make this a scene and cleanup GameManager.
## Research what should be in the GameManager.


## A reference to the player.
var player: Player
## Unlockable flags for the player.
var player_unlockables = {
	scale_gun = true,
	freeze_ray = false,
	bomb_launcher = false
}
## Marks the position where the player will respawn.
var last_respawn_position: Vector2

## A reference to the World scene.
var world: Node2D

# Audio stream resources
var _player_died_audio_resource = preload("res://shared_resources/audio/died.ogg") as AudioStream


func _ready() -> void:
	_init_connections()


func _init_connections() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.player_respawn_point_set.connect(_on_player_respawn_point_set)
	SignalBus.unlock_weapon.connect(_on_unlock_weapon)


func _respawn_player() -> void:
	player.show()
	Utils.ProcessUtils.toggle_processing(player.state_machine, true)
	
	player.velocity = Vector2.ZERO
	player.global_position = last_respawn_position
	player.state_machine.change_state(player.idle_state)


# Signal callbacks.
func _on_player_respawn_point_set(respawn_position: Vector2):
	last_respawn_position = respawn_position


func _on_player_died() -> void:
	player.hide()
	Utils.ProcessUtils.toggle_processing(player.state_machine, false)
	
	var params := AudioManager.PlaySoundParams.new()
	params.pitch_scale = 0.5

	await AudioManager.play_sound(_player_died_audio_resource, params).finished
	
	_respawn_player()


func _on_unlock_weapon(weapon_type: Enums.WeaponType) -> void:
	print("GameManager -> _on_unlock_weapon -> ", Enums.WeaponType.keys()[weapon_type])

	match weapon_type:
		Enums.WeaponType.SCALE_GUN:
			player_unlockables.scale_gun = true
		Enums.WeaponType.BOMB_LAUNCHER:
			player_unlockables.bomb_launcher = true
		Enums.WeaponType.FREEZE_RAY:
			player_unlockables.freeze_ray = true
	
	GameManager.player.unlock_weapons()
