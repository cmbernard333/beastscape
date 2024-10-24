class_name AttackIdle extends State

###
## AttackIdle has one job: get you to the Attack state that is appropriate
## Cool down
###

@export var light_attack_state_name: String = "LightAttack"
@export var jump_attack_state_name: String = "JumpAttack"
@export var attack_meta_state_name: String = "Attack"

var characterSprite: Node2D

func enter() -> void:
	# don't play an animation
	characterSprite = character.sprite
	
func process_input(event: InputEvent) -> void:
	var action: String = input_component.get_input(input_states)
	if action == attack_meta_state_name:
		if movement_component.is_on_ground(characterSprite):
			transitioned.emit(light_attack_state_name)
		else:
			transitioned.emit(jump_attack_state_name)

func _ready() -> void:
	input_states = {"Attack": attack_meta_state_name}
