extends Resource

###
## Primary physics stats resource. Controls the height of a jump, how fast a 
## body ascends and falls, the acceleration of a body, the gravity, 
## and friction.
###

class_name PhysicsStats

@export var jump_height: float = 64.0
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.5
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0, 1.0) var acceleration = 0.25

var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak ** 2)) * -1.0
var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent ** 2)) * -1.0
