extends Camera2D
# TODO: Implement proper look ahead offset

@export var sprite: AnimatedSprite2D
@export var look_ahead_offset: float

# var _last_flip_value: bool

# func _physics_process(delta: float) -> void:
# 	if _last_flip_value == sprite.flip_h: return

# 	if sprite.flip_h:
# 		# Look left
# 		_change_offset(-look_ahead_offset)
# 	else:
# 		# Look right
# 		_change_offset(look_ahead_offset)


# func _change_offset(lookahead: float) -> void:
# 	var tween = get_tree().create_tween()
# 	var new_offset := offset
# 	new_offset.x = lookahead
# 	tween.tween_property(self, "offset", new_offset, 0.5)

# 	_last_flip_value = sprite.flip_h
