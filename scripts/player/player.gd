class_name Player
extends CharacterBody2D


#region Export Variables
@export_group("Movement")
@export var movement_speed: float = 300.0

@export_group("Jump")
@export var jump_force: float = 400.0
## Max [member CharacterBody2D.velocity.y] the player can achieve while falling.
@export var terminal_velocity: float = 500.0
## Gravity multiplier when player is falling.
## Only applied after jump force.
@export var gravity_multiplier: float = 1.0
#endregion

#region Private Variables
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
#endregion


#region Built-in Virtual Methods
func _physics_process(delta: float) -> void:
	move_player()
#endregion


#region Public Methods
func move_player() -> void:
	var delta: float = get_physics_process_delta_time()
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += _gravity * gravity_multiplier * delta
		else:
			velocity.y += _gravity * delta
		
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump(jump_force)
	
	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()


func jump(force: float) -> void:
	velocity.y = -force
#endregion
