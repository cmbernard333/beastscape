class_name LightAttack extends State

@export var attack_idle_state_name: String = "AttackIdle"
@export var light_attack_anim_1: String = "SpriteAnimations_light_attack"
@export var light_attack_anim_2: String = "SpriteAnimations_light_attack_2"

###
## LightAttack state needs to keep the animation going until its finished
## LightAttack can transition to another light attack
## TODO: LightAttack state also has a hitbox that can collide with enemies
###

func _get_attack_animation(previous_anim: String) -> String:
	if previous_anim == light_attack_anim_1:
		return light_attack_anim_2
	return light_attack_anim_1
	
func enter() -> void:
	# set the attack animation as we enter
	animation_name = self.states_store.get_store_key(
		StatesStore.StatesStoreKey.PLAYER_ATTACK_ANIMATION,
		light_attack_anim_1)
	super.enter()

func exit(new_state: State) -> void:
	# set the next animation
	states_store.set_store_key(StatesStore.StatesStoreKey.PLAYER_ATTACK_ANIMATION,
		_get_attack_animation(animation_name))
	super.exit(new_state)

func physics_update(_delta: float) -> void:
	if !animation_playing:
		transitioned.emit(attack_idle_state_name)
	
func _ready() -> void:
	animation_name = "SpriteAnimations_light_attack"
	input_states = {"Attack":"LightAttack"}
