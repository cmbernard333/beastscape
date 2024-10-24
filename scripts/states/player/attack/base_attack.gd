class_name BaseAttack extends State

###
## Attack state is a metastate that transitions to a different type of attack
## based on an attribute of the character
## TODO: hierarchical state machines can be made by using "Meta" states that can transfer control
## to other states.
## TODO: the child states beneath a given state need to be registered to the machine as well so they
## can access everything the "Meta" state has access to.
###

@export var attack_idle_state_name: String = "AttackIdle"

var characterSprite: Node2D

func enter() -> void:
	self.animation_state_tree.set("parameters/conditions/is_attacking", true)
	characterSprite = character.sprite
	super.enter()
	# Audio.play_sfx(Audio.SFX.PlayerAttack)

func exit(new_state: State) -> void:
	self.animation_state_tree.set("parameters/conditions/is_attacking", false)

func physics_update(delta: float) -> void:
	if !animation_playing:
		transitioned.emit(attack_idle_state_name)
	
func _ready() -> void:
	# chain attacks together
	input_states = {"Attack": "Attack"}
