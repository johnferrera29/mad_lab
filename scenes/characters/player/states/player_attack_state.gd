class_name PlayerAttackState
extends State


signal actor_idle
signal actor_ran
signal actor_jumped
signal actor_fell

@export var actor: Player
@export var animator: AnimatedSprite2D

@onready var aiming_audio := $AimingAudio as AudioStreamPlayer


func state_enter(msg: Dictionary = {}) -> void:
	actor.velocity = Vector2.ZERO
	actor.weapon_manager.toggle_weapon_manager(true)

	animator.play("attack")
	aiming_audio.play()

	SignalBus.weapon_drawn.emit(actor.weapon_manager.weapon_list.size())

	_tween_camera_zoom(Vector2(0.95, 0.95))


func state_exit() -> void:
	actor.weapon_manager.toggle_weapon_manager(false)
	_remove_target_highlights()

	aiming_audio.stop()
	
	SignalBus.weapon_withdrawn.emit()

	_tween_camera_zoom(Vector2.ONE)


func state_handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		actor_jumped.emit()
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		actor_ran.emit()
	
	if Input.is_action_just_pressed("change_weapon_next"):
		_remove_target_highlights()
		var next_weapon := actor.weapon_manager.scroll_through_weapons(WeaponManager.SCROLL_DIRECTION.NEXT)
		actor.weapon_manager.change_weapon(next_weapon)
	
	if Input.is_action_just_pressed("change_weapon_prev"):
		_remove_target_highlights()
		var previous_weapon := actor.weapon_manager.scroll_through_weapons(WeaponManager.SCROLL_DIRECTION.PREVIOUS)
		actor.weapon_manager.change_weapon(previous_weapon)


func state_physics_process(delta: float) -> void:
	if not actor.is_on_floor():
		actor_fell.emit()
	
	actor.move_and_slide()


## Removes any remaining target highlights applied to the last detected target.
func _remove_target_highlights() -> void:
	var targeting_system = actor.weapon_manager.current_weapon.targeting_system
	if targeting_system:
		targeting_system.reset_targeting_highlight()


func _tween_camera_zoom(zoom: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(actor.camera, "zoom", zoom, 0.2)
