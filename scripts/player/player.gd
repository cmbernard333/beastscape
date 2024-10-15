class_name PlayerCharacter extends CharacterBody2D

@export var physics_stats: PhysicsStats = load(Ref.PHYSICS_RES)
@export var move_speed: float = 120.0

@onready var animation_state_tree: AnimationTree = $AnimationTree
@onready var animations_playback: AnimationNodeStateMachinePlayback = animation_state_tree.get("parameters/playback")
@onready var attack_states: StatesManager = $AttackStateManager
@onready var movement_states: StatesManager = $MovementStatesManager
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_component: InputComponent = $InputComponent

enum FacingDirection {LEFT=0, RIGHT=1}

# Character always starts facing right
var facing_direction: FacingDirection = FacingDirection.RIGHT
var state_managers: Array[StatesManager] = []

# add a new state manager to the player node
func add_state_manager(
		state_manager: StatesManager, 
		initial_state_name: String = ""):
	state_manager.init_states(
			self, 
			animation_state_tree,
			animation_state_tree.animation_finished, # TODO: this is redundant now
			initial_state_name, 
			input_component)
	state_managers.append(state_manager)
	state_manager.state_changed.connect(_on_state_change)

# change the direction of the animation
func set_animation_direction(horizontal: float = self.velocity.x) -> void:
	if horizontal != 0:
		sprite.scale.x = sign(horizontal)
		if sprite.scale.x < 0:
			facing_direction = FacingDirection.LEFT
		else:
			facing_direction = FacingDirection.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state_manager(movement_states, "Idle")
	add_state_manager(attack_states, "AttackIdle")

func _unhandled_input(event: InputEvent):
	# TODO: cannot handle input if dead
	for state_manager: StatesManager in state_managers:
			state_manager.input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for state_manager: StatesManager in state_managers:
		state_manager.physics_update(delta)

# Signals

func _on_state_change(previous_state_name: String, next_state_name: String, state_manager_name: String):
	Logger.log_print(2, "%s :: StateManager %s: %s > %s ", \
		[get_name(), state_manager_name, previous_state_name, next_state_name])
