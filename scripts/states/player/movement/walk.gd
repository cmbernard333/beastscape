class_name WalkState extends State

@export var fall_state_name: String = "Fall"
@export var idle_state_name: String = "Idle"
@export var jump_state_name: String = "Jump"
@export var walk_state_name: String = "Walk"

var coyote_frames: int = 6
var coyote = false
var last_floor = false

# override
func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_walking", true)
	coyote = false
	super.enter()

func exit() -> void:
	coyote = false
	self.animation_state_tree.set("parameters/conditions/is_walking", false)
	
# gets the gravitational force applied
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
func input(_event: InputEvent) -> void:
	var action: String = input_component.get_input(input_states)
	if action != InputComponent.NO_ACTION:
		match action:
			"Jump":
				if character.is_on_floor() or coyote:
					transitioned.emit(action)
			_:
				transitioned.emit(action)

func physics_update(delta: float) -> void:
	# coyote time last on floor
	last_floor = character.is_on_floor()
	# change velocity
	if !coyote:
		character.velocity.y += get_gravity_float() * delta
	character.velocity.x = get_input_velocity(character.move_speed)
	
	character.set_animation_direction()
	
	character.move_and_slide()
	
	# walked off the platform and were previously on a platform
	if !character.is_on_floor() and last_floor:
		if !coyote:
			coyote = true
			$CoyoteTimer.start()
		else:
			transitioned.emit(fall_state_name)
			return
	
	if character.velocity == Vector2.ZERO or input_component.get_all_input_pressed(["MoveLeft","MoveRight"]):
		transitioned.emit(idle_state_name)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_name = "SpriteAnimations_walk"
	input_states = {
		"MoveLeft" : walk_state_name,
		"MoveRight" : walk_state_name,
		"Jump" : jump_state_name,
		# "Dash" : "Dash2" # added later
		}
	$CoyoteTimer.wait_time = coyote_frames / 60.0

# Signals

func _on_coyote_timer_timeout():
	coyote = false
