class_name FallState extends State

@export var walk_state_name: String = "Walk"
@export var idle_state_name: String = "Idle"

func exit(new_state: State) -> void:
	super.exit(new_state)
	self.animation_state_tree.set("parameters/conditions/is_jumping", false)

# gets the gravitational force applied
func get_gravity_float() -> float:
	if character.velocity.y < 0.0:
		return character.physics_stats.jump_gravity
	else:
		return 0.0 if character.is_on_floor() else character.physics_stats.fall_gravity

func get_input_velocity(move_speed: float) -> float:
	var horizontal: float = 0.0
	
	var direction: Vector2 = input_component.get_movement_direction()
	
	# TODO: horizontal movement vs vertical movement
	horizontal = lerp(character.velocity.x, direction.x * character.move_speed, 
		character.physics_stats.acceleration)
	
	return horizontal

func physics_update(delta: float) -> void:
	# apply gravity
	character.velocity.y += get_gravity_float() * delta
	character.velocity.x = get_input_velocity(character.move_speed)
	
	character.set_animation_direction()
	
	character.move_and_slide()
	
	if character.is_on_floor():
		if is_equal_approx(character.velocity.x, 0.0):
			transitioned.emit("Idle")
		else:
			transitioned.emit("Walk")

func _ready() -> void:
	animation_name = "SpriteAnimations_jump"
	# input_states = {"Dash" : "Dash2"} # added later
