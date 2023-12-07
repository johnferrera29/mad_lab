class_name ProjectileLauncher
extends Node2D
## A launcher that fires off a [Projectile].
## 
## Use this component with composition.


## Resource that will be used to instantiate projectiles.
@export var projectile_scene: PackedScene
## The lifespan of the projectile in seconds before it's automatically destroyed.
@export var projectile_lifespan: float
## Speed of the projectile.
@export var launch_speed: float
## Determines how fast we can launch the next projectile.
@export var launch_interval: float

## Timer used to limit projectile launches based on [member launch_interval].
var launch_timer: Timer 


func _ready() -> void:
	_init_timer()

	# Currently setting this to always process for reload progress indicator in the hud.
	process_mode = Node.PROCESS_MODE_ALWAYS


func _physics_process(delta: float) -> void:
	_check_reload_progress()


## Launches a [param projectile].
## Returns a bool if projectile was successfully launched.
func launch_projectile(projectile: Projectile) -> bool:
	if not launch_timer.is_stopped():
		return false

	get_tree().get_first_node_in_group("world").add_child(projectile)
	
	launch_timer.start()

	return true


## Returns a projectile configured based on parameters.
func create_projectile(spawn_position: Vector2, spawn_rotation: float, velocity: Vector2, lifespan: float) -> Projectile:
	var projectile = projectile_scene.instantiate() as Projectile

	projectile.global_position = spawn_position
	projectile.global_rotation = spawn_rotation
	projectile.projectile_velocity = velocity
	projectile.projectile_lifespan = lifespan

	projectile.top_level = true

	return projectile


func _init_timer() -> void:
	launch_timer = Timer.new()
	launch_timer.name = "LaunchIntervalTimer"
	launch_timer.one_shot = true
	launch_timer.wait_time = launch_interval
	
	add_child(launch_timer)


func _check_reload_progress() -> void:
	# Only emit progress if the parent's process mode is not disabled.
	# Doing this to prevent incorrect reload progress in the HUD weapon indicator.
	if not launch_timer.is_stopped() and get_parent().process_mode != PROCESS_MODE_DISABLED:
		var reload_progress := 1 - (launch_timer.time_left / launch_timer.wait_time)
		SignalBus.weapon_reload_progressed.emit(reload_progress)
