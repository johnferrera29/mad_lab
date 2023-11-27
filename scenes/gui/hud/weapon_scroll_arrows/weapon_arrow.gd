class_name WeaponArrow
extends Sprite2D


@onready var animator := $AnimationPlayer as AnimationPlayer


func play_clicked_animation() -> void:
	animator.play("clicked")
