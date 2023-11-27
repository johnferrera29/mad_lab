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

## Currently selected weaon.
var current_weapon: Weapon
## A dictionary of weapons inside Weapon Manager. Node's lowercased name is used as the key.
var weapon_dictionary: Dictionary = {}
## An array of weapons. Contains the same weapons as [member weapon_dictionary] but in array form.
## The order of the array is based on the child's order in the editor.
var weapon_list: Array[Weapon]


func _ready() -> void:
	for child in get_children():
		if child is Weapon:
			weapon_dictionary[child.name.to_lower()] = child
			weapon_list.append(child as Weapon)
			child.disable_weapon()
		else:
			push_warning("Weapon Manager contains a child node that is not derived from Weapon class.")
	
	change_weapon(initial_weapon)


## Changes currently selected weapon to [param weapon].
func change_weapon(weapon: Weapon) -> void:
	if not weapon: return
	
	if current_weapon:
		current_weapon.disable_weapon()
	
	current_weapon = weapon
	current_weapon.enable_weapon()


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
	
	# TODO: Move this to more appropriate location.
	SignalBus.weapon_changed.emit(index)

	return weapon_list[index]


## Enables or disables weapon manager.
func toggle_weapon_manager(flag: bool) -> void:
	Utils.ProcessUtils.toggle_processing(self, flag)

	if flag:
		self.show()
	else:
		self.hide()
