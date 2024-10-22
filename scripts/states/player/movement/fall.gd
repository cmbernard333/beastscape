class_name FallState extends State

@export var walk_state_name: String = "Walk"
@export var idle_state_name: String = "Idle"

var characterSprite: Node2D # AnimatedSprite2D or Sprite2D

# the calculated jump velocity based on time
var _jump_velocity: float = 0.0

func enter() -> void:
	super.enter()
	_jump_velocity = self.states_store.get_store_key(
		StatesStore.StatesStoreKey.PLAYER_JUMP_VELOCITY
		) as float
	# TODO: applies specifically to PlayerCharacter right now
	characterSprite = character.sprite

func exit(new_state: State) -> void:
	super.exit(new_state)
	self.animation_state_tree.set("parameters/conditions/is_jumping", false)
	_jump_velocity = 0.0
	characterSprite.position.y = 0.0

# gets the gravitational force applied
func get_gravity_float() -> float:
	if _jump_velocity < 0.0:
		return character.physics_stats.jump_gravity
	else:
		return 0.0 if movement_component.is_on_ground(characterSprite) else character.physics_stats.fall_gravity

func physics_update(delta: float) -> void:
	var direction := input_component.get_movement_direction()
	var input_velocity := movement_component.get_input_velocity(character.velocity, direction, character.move_speed)

	# apply gravity i.e. downward movement
	characterSprite.position.y += _jump_velocity * delta

	_jump_velocity += get_gravity_float() * delta

	# calculate lateral velocity
	character.velocity = input_velocity
	
	character.set_animation_direction()
	
	character.move_and_slide()
	
	if movement_component.is_on_ground(characterSprite):
		if is_equal_approx(character.velocity.x, 0.0):
			transitioned.emit("Idle")
		else:
			transitioned.emit("Walk")

func _ready() -> void:
	animation_name = "SpriteAnimations_jump"
