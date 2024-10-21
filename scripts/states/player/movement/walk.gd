class_name WalkState extends State

@export var fall_state_name: String = "Fall"
@export var idle_state_name: String = "Idle"
@export var jump_state_name: String = "Jump"
@export var walk_state_name: String = "Walk"

var last_floor = false

# override
func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_walking", true)
	super.enter()

func exit(new_state: State) -> void:
	self.animation_state_tree.set("parameters/conditions/is_walking", false)
	
# gets the gravitational force applied
func get_gravity_float() -> float:
	if character.velocity.y < 0.0:
		return character.physics_stats.jump_gravity
	else:
		return character.physics_stats.fall_gravity

func physics_update(delta: float) -> void:
	var direction := input_component.get_movement_direction()
	# TODO: gravity doesn't apply in the walk state anymore
	# character.velocity.y += get_gravity_float() * delta
	character.velocity = movement_component.get_input_velocity(character.velocity, direction, character.move_speed)
	
	character.set_animation_direction()
	
	character.move_and_slide()
	
	if character.velocity.is_zero_approx() or input_component.get_all_input_pressed(["MoveLeft","MoveRight"]):
		transitioned.emit(idle_state_name)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_name = "SpriteAnimations_walk"
	input_states = {
		"MoveUp": walk_state_name,
		"MoveDown": walk_state_name,
		"MoveLeft" : walk_state_name,
		"MoveRight" : walk_state_name,
		"Jump" : jump_state_name,
		# "Dash" : "Dash2" # added later
		}
