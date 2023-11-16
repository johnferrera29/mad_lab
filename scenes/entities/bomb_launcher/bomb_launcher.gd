class_name BombLauncher
extends Node2D
## A bomb launcher... that launches bombs. Launches a [BombProjectile] towards target.
##
## Target object must extend an [InteractableObject] and contains a [BreakableComponent].


@export var bomb_projectile: PackedScene
## The speed of the bomb projectile.
@export var launch_speed: float
## Determines how fast we can launch the next projectile.
@export_range(0.1, 10.0, 0.1) var launch_interval: float
## Time before the bomb projectile will automatically detonate.
## Fallback incase bomb does not collide with another body.
@export_range(0.1, 10.0, 0.1) var time_before_detonation: float

@export_group("Target Highlight")
## Outline when target is detected by [TargetingSystem]
@export var target_highlight_size: float = 1.0
@export var target_highlight_color: Color = Color.WHITE

## Custom [ShaderMaterial] that contains the 2D outline shader.
var outline_material: ShaderMaterial = preload("res://shared_resources/shaders/2D_outline_outer.tres")

@onready var projectile_container := $ProjectileContainer as Node
@onready var launch_interval_timer := $LaunchIntervalTimer as Timer


func _ready() -> void:
	# Initialize shader material related parameters.
	outline_material.set_shader_parameter("line_thickness", target_highlight_size)
	outline_material.set_shader_parameter("line_color", target_highlight_color)

	# Set launch interval wait time.
	launch_interval_timer.wait_time = launch_interval


func add_highlight(sprite: Node2D) -> void:
	sprite.material = outline_material


func remove_highlight(sprite: Node2D) -> void:
	sprite.material = null


## Launches a bomb projectile towards target direction at a particular [param speed].
func launch_bomb(target: Node2D, speed: float, detonation_time: float) -> void:
	if not launch_interval_timer.is_stopped(): return

	var direction := global_position.direction_to(target.global_position)
	create_bomb_projectile(direction * speed, detonation_time)

	launch_interval_timer.start()


func create_bomb_projectile(projectile_velocity: Vector2, detonation_time: float) -> void:
	var bomb = bomb_projectile.instantiate() as BombProjectile

	bomb.global_position = global_position
	bomb.projectile_velocity = projectile_velocity
	bomb.detonation_time = detonation_time

	projectile_container.add_child(bomb)


func _on_targeting_system_target_detected(target: InteractableObject) -> void:
	var breakable_component := target.breakable_component
	if breakable_component:
		add_highlight(breakable_component.sprite)


func _on_targeting_system_target_interacted(target: InteractableObject) -> void:
	var breakable_component := target.breakable_component
	if breakable_component:
		launch_bomb(breakable_component.target, launch_speed, time_before_detonation)


func _on_targeting_system_target_lost(target: InteractableObject) -> void:
	var breakable_component := target.breakable_component
	if breakable_component:
		remove_highlight(breakable_component.sprite)
