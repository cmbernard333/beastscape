class_name InputComponent 
extends Node

###
## InputComponent allows customizable input for a StateManager.
## e.g. PlayerCharacter2 uses PlayerInputComponent to collect input events
###

# NO_ACTION means do nothing - do not proceed to the next state
const NO_ACTION: String = "NO_ACTION"

func get_input(_input_states: Dictionary) -> String:
	return NO_ACTION

func get_any_input_pressed(input_action_names: Array[String]) -> bool:
	for input: String in input_action_names:
		if Input.is_action_pressed(input):
			return true
	return false

func get_all_input_pressed(input_action_names: Array[String]) -> bool:
	for input: String in input_action_names:
		if !Input.is_action_pressed(input):
			return false
	return true

func get_movement_direction() -> float:
	return 0
