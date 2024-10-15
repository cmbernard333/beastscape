class_name PlayerInputComponent 
extends InputComponent

###
## PlayerInput component is run by taking in a collection of input states
## and checking if any of them have been triggered by the press of a key.
###

##
## get_input takes a dictionary of input states and returns the action
## just pressed by the player.
##
func get_input(input_states: Dictionary) -> String:
	for action_name: String in input_states.keys():
		# TODO: presently this causes a bug where if you hold MoveLeft or MoveRight
		# then press the opposite key, followed by releasing at least one, the
		# player stays stationary
		if Input.is_action_just_pressed(action_name):
			return input_states[action_name]
	return InputComponent.NO_ACTION

func get_movement_direction() -> float:
	return Input.get_axis("MoveLeft", "MoveRight")
