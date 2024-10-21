class_name Attack extends State

###
## Attack state is a metastate that transitions to a different type of attack
## based on an attribute of the character
## TODO: hierarchical state machines can be made by using "Meta" states that can transfer control
## to other states.
## TODO: the child states beneath a given state need to be registered to the machine as well so they
## can access everything the "Meta" state has access to.
###

@export var attack_idle_state_name: String = "AttackIdle"

@onready var light_attack: State = $LightAttack
@onready var jump_attack: State = $JumpAttack

var current_attack_state: State

func physics_update(_delta: float) -> void:
	if !animation_playing:
		transitioned.emit(attack_idle_state_name)
	
func _ready() -> void:
	animation_name = "SpriteAnimations_light_attack"
	light_attack = get_node("LightAttack")
	jump_attack = get_node("JumpAttack")

func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_attacking", true)
	if character.is_on_floor():
		current_attack_state = light_attack
	else:
		current_attack_state = jump_attack
	current_attack_state.enter()
	# Audio.play_sfx(Audio.SFX.PlayerAttack)

func exit(new_state: State) -> void:
	self.animation_state_tree.set("parameters/conditions/is_attacking", false)
