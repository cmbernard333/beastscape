class_name JumpState
extends State

###
## JumpState - unlike a traditional platformer jump state, this jump state modifies the character
## sprite's y position over time to make it appear like it is jumping.
## It treats the X and Y translation as moving the character around the plane
###

@export var fall_state_name: String = "Fall"
@export var walk_state_name: String = "Walk"
@export var idle_state_name: String = "Idle"

var characterSprite: Node2D # AnimatedSprite2D or Sprite2D

# the calculated jump velocity based on time
var _jump_velocity: float = 0.0

# override
func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_jumping", true)
	super.enter()
	# TODO: applies specifically to PlayerCharacter right now
	characterSprite = character.sprite
	# self.states_store.set_store_key(StatesStore.StatesStoreKey.PLAYER_JUMP_START, character.global_position)
	_jump_velocity = movement_component.get_jump_velocity()
	# Audio.play_sfx(Audio.SFX.Jump)

func exit(new_state: State) -> void:
	self.states_store.set_store_key(
		StatesStore.StatesStoreKey.PLAYER_JUMP_VELOCITY, 
		_jump_velocity)
	super.exit(new_state)

func get_gravity_float() -> float:
	if characterSprite.position.y < 0.0:
		return character.physics_stats.jump_gravity
	else:
		return character.physics_stats.fall_gravity

# override
func physics_update(delta: float) -> void:
	# TODO: handle being knocked out of the air
	var direction := input_component.get_movement_direction()
	var input_velocity := movement_component.get_input_velocity(character.velocity, direction, character.move_speed)
	
	# TODO: instead of applying the y velocity to the character - apply it to the sprite's position
	characterSprite.position.y += _jump_velocity * delta

	_jump_velocity += get_gravity_float() * delta
	
	# calculate lateral velocity
	character.velocity = input_velocity
	
	character.set_animation_direction()
	
	character.move_and_slide()
	
	if !movement_component.is_on_ground(characterSprite):
		transitioned.emit(fall_state_name)
	
	if movement_component.is_on_ground(characterSprite):
		if character.velocity.x > 0:
			transitioned.emit(walk_state_name)
		else:
			transitioned.emit(idle_state_name)

func _ready() -> void:
	animation_name = "SpriteAnimations_jump"
