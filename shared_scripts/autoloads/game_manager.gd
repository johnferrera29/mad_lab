extends Node
## Manages the game state.
## 
## TODO: Make this an autoloaded scene scene and cleanup GameManager.
## Research what should be in the GameManager.


## A reference to the World scene.
var world: Node2D
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


#region Signal Callbacks.
func _on_player_respawn_point_set(respawn_position: Vector2):
	last_respawn_position = respawn_position


func _on_player_died() -> void:
	player.hide()
	Utils.ProcessUtils.toggle_processing(player.state_machine, false)
	
	var audio_resource = preload("res://shared_resources/audio/died.ogg") as AudioStream
	var params := AudioManager.PlaySoundParams.new()
	params.pitch_scale = 0.5
	
	await AudioManager.play_sound(audio_resource, params)
	
	_respawn_player()


func _on_unlock_weapon(weapon_type: Enums.WeaponType) -> void:
	match weapon_type:
		Enums.WeaponType.SCALE_GUN:
			player_unlockables.scale_gun = true
		Enums.WeaponType.BOMB_LAUNCHER:
			player_unlockables.bomb_launcher = true
		Enums.WeaponType.FREEZE_RAY:
			player_unlockables.freeze_ray = true
	
	GameManager.player.weapon_manager.unlock_weapons()
#endregion
