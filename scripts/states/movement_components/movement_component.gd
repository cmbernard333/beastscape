class_name MovementComponent extends Node

@export var physics_stats: PhysicsStats = load("res://resources/beat-em-up_physics.tres")

func get_jump_velocity() -> float:
	return ((2.0 * physics_stats.jump_height) 
		/ physics_stats.jump_time_to_peak) * -1.0

func get_input_velocity(
	current_velocity: Vector2, 
	direction: Vector2, 
	move_speed: float) -> Vector2:
	var horizontal: float = 0.0
	var vertical: float = 0.0
	
	# handle x direction
	if direction.x != 0:
		horizontal = lerp(current_velocity.x, direction.x * move_speed, physics_stats.acceleration)
	else:
		horizontal = lerp(current_velocity.x, 0.0, physics_stats.friction)
	
	# handle y direction
	if direction.y  != 0:
		vertical = lerp(current_velocity.y, direction.y * move_speed, physics_stats.acceleration)
	else:
		vertical = lerp(current_velocity.y, 0.0, physics_stats.friction)
	
	Logger.log_print(2, "%s:: movement velocity {%f, %f}", [owner.get_name(), horizontal, vertical])
	
	return Vector2(horizontal, vertical)
