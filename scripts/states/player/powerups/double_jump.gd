class_name DoubleJump extends FallState

###
## DoubleJump is an extension of the FallState that allows jumping 
## an additional time.
## It can replace the "Jump" state in the players movement state machine
###

@export var jump_state_name: String = "Jump"

var double_jump: bool = true

# override
func process_input(_event: InputEvent) -> void:
	var action: String = input_component.get_input(input_states)
	if action != InputComponent.NO_ACTION:
		match action:
			"Jump":
				if double_jump:
					double_jump = false
					transitioned.emit(action)
			_:
				transitioned.emit(action)

func physics_update(delta: float) -> void:
	super.physics_update(delta)
	# reset jumps
	if character.is_on_floor():
		double_jump = true

func _ready() -> void:
	super._ready()
	input_states["Jump"] = jump_state_name
