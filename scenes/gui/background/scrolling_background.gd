extends ParallaxBackground


@export var scroll_speed: Vector2
@export var background_texture: CompressedTexture2D

var _background_texture_size: Vector2

@onready var _sprite: Sprite2D = $ParallaxLayer/Sprite2D as Sprite2D


func _ready() -> void:
	_set_background_texture(background_texture)


func _physics_process(delta: float) -> void:
	_scroll_background(delta)


func _set_background_texture(texture: CompressedTexture2D) -> void:
	if texture:
		_sprite.texture = background_texture
		_background_texture_size = background_texture.get_size()


func _scroll_background(delta: float) -> void:
	_sprite.region_rect.position += scroll_speed * delta
	
	if _sprite.region_rect.position > _background_texture_size:
		_sprite.region_rect.position = Vector2.ZERO
