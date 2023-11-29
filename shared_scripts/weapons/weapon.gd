class_name Weapon
extends Node2D
## Base class for all weapon types.


## Determines the type of weapon.
var weapon_type: Enums.WeaponType


## Make weapon visibile and enable its processing.
func enable_weapon() -> void:
	show()
	Utils.ProcessUtils.toggle_processing(self, true)


## Hide weapon and disable its processing.
func disable_weapon() -> void:
	hide()
	Utils.ProcessUtils.toggle_processing(self, false)
