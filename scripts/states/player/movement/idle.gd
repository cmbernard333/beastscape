class_name IdleState
extends State

####
## Primary idle state for a player character
## when the state is entered, it plays the idle animation and waits for other states
####

@export var walk_state_name: String = "Walk"
@export var jump_state_name: String = "Jump"
@export var fall_state_name: String = "Fall"

func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_idle", true)
	super.enter()

func exit() -> void:
	super.exit()
	self.animation_state_tree.set("parameters/conditions/is_idle", false)

# gets the gravitational force applied
func get_gravity_float() -> float:
	if character.velocity.y < 0.0:
		return character.physics_stats.jump_gravity
	else:
		return character.physics_stats.fall_gravity

func physics_update(delta: float) -> void:
	# apply gravity
	character.velocity.y += get_gravity_float() * delta
	# apply friction
	character.velocity.x = lerp(character.velocity.x, 0.0, character.physics_stats.friction)

	character.move_and_slide()
	
	if !character.is_on_floor():
		transitioned.emit(fall_state_name)
	
	if input_component.get_any_input_pressed(["MoveLeft","MoveRight"]) and\
			 !input_component.get_all_input_pressed(["MoveLeft","MoveRight"]):
		transitioned.emit(walk_state_name)

func _ready() -> void:
	animation_name = "SpriteAnimations_idle"
	input_states = {
		"MoveLeft": walk_state_name,
		"MoveRight": walk_state_name,
		"Jump": jump_state_name,
		# "Dash": "Dash2" # added later
	}
