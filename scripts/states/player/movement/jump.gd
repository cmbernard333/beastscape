class_name JumpState
extends State

@export var fall_state_name: String = "Fall"
@export var walk_state_name: String = "Walk"
@export var idle_state_name: String = "Idle"

# override
func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_jumping", true)
	super.enter()
	character.velocity.y = get_jump_velocity()
	# Audio.play_sfx(Audio.SFX.Jump)

func exit() -> void:
	super.exit()

func get_jump_velocity() -> float:
	return ((2.0 * character.physics_stats.jump_height) 
		/ character.physics_stats.jump_time_to_peak) * -1.0

func get_gravity_float() -> float:
	if character.velocity.y < 0.0:
		return character.physics_stats.jump_gravity
	else:
		return character.physics_stats.fall_gravity

func get_input_velocity(move_speed: float) -> float:
	var horizontal: float = 0.0
	
	var direction: float = input_component.get_movement_direction()
	
	if direction != 0:
		horizontal = lerp(character.velocity.x, direction * character.move_speed, 
			character.physics_stats.acceleration)
	else:
		horizontal = lerp(character.velocity.x, 0.0, character.physics_stats.friction)
	
	return horizontal

# override
func physics_update(delta: float) -> void:
	character.velocity.y += get_gravity_float() * delta
	character.velocity.x = get_input_velocity(character.move_speed)
	
	character.set_animation_direction()
	
	character.move_and_slide()
	
	if !character.is_on_floor():
		transitioned.emit(fall_state_name)
	
	if character.is_on_floor():
		if character.velocity.x > 0:
			transitioned.emit(walk_state_name)
		else:
			transitioned.emit(idle_state_name)

func _ready() -> void:
	animation_name = "SpriteAnimations_jump"
