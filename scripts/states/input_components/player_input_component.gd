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
		# if Input.is_action_just_pressed(action_name):
		if InputBuffer.is_action_press_buffered(action_name):
			return input_states[action_name]
	return InputComponent.NO_ACTION

func get_movement_direction() -> Vector2:
	var direction := Vector2(
		Input.get_axis("MoveLeft", "MoveRight"),
		Input.get_axis("MoveUp", "MoveDown")
		)
	Logger.log_print(2, "Input Direction %s", [direction])
	return direction
