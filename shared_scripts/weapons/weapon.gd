class_name Weapon
extends Node2D
## Base class for all weapon types.


## Determines the type of weapon.
var weapon_type: Enums.WeaponType
## Flag whether the weapon is enabled or disabled.
var is_enabled: bool = true


## Make weapon visibile and enable its processing.
func enable_weapon() -> void:
	is_enabled = true
	show()
	Utils.ProcessUtils.toggle_processing(self, true)


## Hide weapon and disable its processing.
func disable_weapon() -> void:
	is_enabled = false
	hide()
	Utils.ProcessUtils.toggle_processing(self, false)
