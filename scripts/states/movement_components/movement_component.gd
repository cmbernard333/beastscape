class_name MovementComponent extends Node

###
## MovementComponent is an interface for determining the velocity generating by input and gravity
## This MovementComponent is for top-down movement
###

@export var physics_stats: PhysicsStats

# retrieve the jump velocity for this movement component
func get_jump_velocity() -> float:
	return 0.0

# retrieve the input velocity for this movement component
func get_input_velocity(
	current_velocity: Vector2, 
	direction: Vector2, 
	move_speed: float) -> Vector2:
	return Vector2.ZERO

# test if the provided Node2D is on the ground
# e.g. CharacterBody2D.is_on_floor()
func is_on_ground(character: Node2D) -> bool:
	if character is CharacterBody2D:
		return character.is_on_floor()
	else:
		return character.position.y >= 0
