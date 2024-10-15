class_name AttackIdle extends State

###
## AttackIdle has one job: get you to the Attack state
## Cool down
###

@export var attack_state_name: String = "Attack"

func enter() -> void:
	# don't play an animation
	pass

func _ready() -> void:
	input_states = {"Attack": attack_state_name}
