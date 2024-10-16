class_name StatesManager
extends Node

# used to initialize the first state
@export var initial_state_name: String = ""

var animation_completed_signal: Signal
var character: CharacterBody2D
var states: Dictionary = {} # the starting point for each state
var current_state: State
var input_buffer: InputBuffer

# state changed in this state machine - used for external observers
signal state_changed(
	previous_state_name: String, 
	next_state_name: String, 
	state_manager_name: String)

func get_current_state() -> String:
	return current_state.get_state_name() if current_state != null else ""

func _on_state_change(new_state: String) -> void:
	change_state(new_state)

func change_state(new_state: String) -> void:
	state_changed.emit(get_current_state(), new_state, get_name())
	if current_state:
		current_state.exit()
		# we replaced this state with a different one
		if current_state.disconnect_after_exit:
			current_state.transitioned.disconnect(_on_state_change)
			animation_completed_signal.disconnect(current_state.on_animation_finished)
	current_state = states[new_state]
	current_state.enter()

# replaces an existing state with a new one. Returns the previous state.
# if a state doesn't exist, it returns null.
func replace_state(state_name: String, new_state: State) -> State:
	var old_state: State = states.get(state_name)
	# make sure we don't automatically disconnect if we are restoring a previous state
	new_state.disconnect_after_exit = false
	new_state.character = character
	# TODO: Note: should get this from self
	new_state.animation_state_tree = character.animation_state_tree
	new_state.transitioned.connect(_on_state_change)
	animation_completed_signal.connect(new_state.on_animation_finished)
	# disconnect the old handler
	if old_state != null:
		old_state.disconnect_after_exit = true
	# TODO: Note: should get this from from self
	new_state.input_component = character.input_component
	states[state_name] = new_state
	return old_state

# Initialize the state machine, giving each state a reference
# to the owner CharacterBody2D
# the owner can set their own base state
func init_states(
		character: CharacterBody2D,
		animations: AnimationTree,
		animation_completed: Signal = Signal(), # useful if states want to wait until their animation finishes
		new_initial_state_name: String = "",
		input_component: InputComponent = InputComponent.new(), # base input does nothing
	) -> void:
	self.character = character
	self.animation_completed_signal = animation_completed
	for state: State in find_children("*", "State"):
		state.register_state(self, character, animations, input_component)
		# make a lookup for the state
		states[state.get_name()] = state
		# make sure a child can signal a state change
		state.transitioned.connect(_on_state_change)
		# connect the on_animation_finished function so children know their animation completed
		if animation_completed:
			animation_completed.connect(state.on_animation_finished)

	if new_initial_state_name == null or new_initial_state_name.is_empty():
		var initial_state: State = get_child(0) as State
		change_state(initial_state.get_name())
	else:
		change_state(new_initial_state_name)

# Pass through function for handling physics processing
func physics_update(delta: float) -> void:
	if current_state != null:
		current_state.physics_update(delta)

# Pass through function for handling input events
func input(event: InputEvent) -> void:
	if current_state != null:
		current_state.input(event)
	
func _ready() -> void:
	pass
