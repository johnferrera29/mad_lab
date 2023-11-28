class_name WeaponManager
extends Node2D
## Class that handles switching between different availble weapons.
##
## TODO: Make this extend StateMachine for better state handling.


## Determines the scroll direction when calling [method scroll_through_weapons].
enum SCROLL_DIRECTION {
	NEXT = 1,
	PREVIOUS = -1
}

@export var initial_weapon: Weapon

@export_group("Weapon Packed Scenes")
@export var scale_gun_resource: PackedScene
@export var bomb_launcher_resource: PackedScene
@export var freeze_ray_resource: PackedScene


## Currently selected weaon.
var current_weapon: Weapon
## A dictionary of weapons inside Weapon Manager. Node's lowercased name is used as the key.
var weapon_dictionary: Dictionary = {}
## An array of weapons. Contains the same weapons as [member weapon_dictionary] but in array form.
## The order of the array is based on the child's order in the editor.
var weapon_list: Array[Weapon]



func _ready() -> void:
	unlock_weapons()


func unlock_weapons() -> void:
	if GameManager.player_unlockables.scale_gun:
		_unlock_weapon(Enums.WeaponType.SCALE_GUN)
	
	if GameManager.player_unlockables.bomb_launcher:
		_unlock_weapon(Enums.WeaponType.BOMB_LAUNCHER)
	
	if GameManager.player_unlockables.freeze_ray:
		_unlock_weapon(Enums.WeaponType.FREEZE_RAY)
	
	# If there is no current weapon and cache is not empty, assign the first weapon as current.
	if not current_weapon and weapon_list.size() != 0:
		change_weapon(weapon_list[0])


## Changes currently selected weapon to [param weapon].
func change_weapon(weapon: Weapon) -> void:
	if not weapon: return
	
	if current_weapon:
		current_weapon.disable_weapon()
	
	current_weapon = weapon
	current_weapon.enable_weapon()

	SignalBus.weapon_changed.emit(current_weapon.weapon_type)


## Scroll through list weapons starting from the [member current_weapon] index inside [member weapon_list].
## Provide optional [param scroll_direction] to determine scrolling direction. Use [enum WeaponManager.SCROLL_DIRECTION].
## Returns null if [member current_weapon] not set.
func scroll_through_weapons(scroll_direction: SCROLL_DIRECTION = SCROLL_DIRECTION.NEXT) -> Weapon:
	if not current_weapon: return

	var max_index := weapon_list.size()
	var index := weapon_list.find(current_weapon) + scroll_direction
	
	# Went over last weapon index.
	if index >= max_index:
		index = 0
	
	# Wend under first weapon index.
	if index <= -1:
		index = weapon_list.size() - 1

	return weapon_list[index]


## Enables or disables weapon manager.
func toggle_weapon_manager(flag: bool) -> void:
	Utils.ProcessUtils.toggle_processing(self, flag)

	if flag:
		self.show()
	else:
		self.hide()


func _unlock_weapon(weapon_type: Enums.WeaponType) -> void:
	match weapon_type:
		Enums.WeaponType.SCALE_GUN:
			var instance := scale_gun_resource.instantiate() as ScaleGun
			instance.name = "ScaleGun"

			if not weapon_dictionary.has(instance.name.to_lower()):
				# print("Player -> Unlock ScaleGun")
				_add_weapon(instance)
		Enums.WeaponType.BOMB_LAUNCHER:
			var instance := bomb_launcher_resource.instantiate() as BombLauncher
			instance.name = "BombLauncher"

			if not weapon_dictionary.has(instance.name.to_lower()):
				# print("Player -> Unlock BombLauncher")
				_add_weapon(instance)
		Enums.WeaponType.FREEZE_RAY:
			var instance := freeze_ray_resource.instantiate() as FreezeRay
			instance.name = "FreezeRay"

			if not weapon_dictionary.has(instance.name.to_lower()):
				# print("Player -> Unlock FreezeRay")
				_add_weapon(instance)


func _add_weapon(weapon: Weapon) -> void:
	add_child(weapon)
	weapon_dictionary[weapon.name.to_lower()] = weapon
	weapon_list.append(weapon)
	weapon.disable_weapon()
