class_name WeaponManager
extends Node2D
## Class that handles switching between different types of weapon.


@export var initial_weapon: Weapon

var current_weapon: Weapon
var weapons: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is Weapon:
			weapons[child.name.to_lower()] = child
			child.disable_weapon()
		else:
			push_warning("Weapon Manager contains a child node that is not derived from virtual Weapon class.")
	
	change_weapon(initial_weapon)


func change_weapon(weapon: Weapon) -> void:
	if not weapon: return
	
	if current_weapon:
		current_weapon.disable_weapon()
	
	current_weapon = weapon
	current_weapon.enable_weapon()
