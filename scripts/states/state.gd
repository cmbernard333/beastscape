class_name State extends Node

###
## State for all states
## represents all possible states (finite)
## Requires a few properties from a CharacterBody2D:
## - physics_stats - the physics_stats resource attached to the CharacterBody2D
###

@export var animation_name: String
@export var animation_state_tree: AnimationTree
@export var character: CharacterBody2D
@export var state_machine_parent: StatesManager

@export var input_states: Dictionary = {} # Action, State
@export var input_component: InputComponent

# the signal used to alert all states the state we just transitioned to
signal transitioned(new_state_name: String)

var disconnect_after_exit: bool = false
var animation_playing: bool = false

# hookup function for signals
func on_animation_finished(animation_name: StringName):
	print("%s :: Animation %s completed" % [get_name(), animation_name])
	animation_playing = false

func enter() -> void:
	# assert here because you should either use it or override it
	assert(animation_name != null or !animation_name.is_empty())
	animation_playing = true
	var animation_playback: AnimationNodeStateMachinePlayback = \
			animation_state_tree.get("parameters/playback")
	animation_playback.travel(animation_name)

# clean up/reset function
func exit() -> void:
	pass

func get_state_name() -> String:
	return get_name()

# Functions to process the state

# process _unhandled_input events
func input(_event: InputEvent) -> void:
	var action: String = input_component.get_input(input_states)
	if action != InputComponent.NO_ACTION:
		transitioned.emit(action)

# run once a frame - similar to _process
# Transition to the next state via `transitioned.emit(new_state_name)`
func update(_delta: float) -> void:
	pass

# run once a frame for physics - similar to _physics_process
# Transition to the next state via `transitioned.emit(new_state_name)`
func physics_update(_delta: float) -> void:
	pass
