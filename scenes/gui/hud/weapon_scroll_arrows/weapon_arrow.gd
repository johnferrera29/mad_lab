class_name WeaponArrow
extends Sprite2D


@onready var _animator := $AnimationPlayer as AnimationPlayer


func play_clicked_animation() -> void:
	_animator.play("clicked")
